require 'spec_helper'

describe Guide do
  let(:language) { create(:haskell) }

  let(:guide_json) do
    {name: 'sample guide',
     description: 'Baz',
     slug: 'mumuki/sample-guide',
     language: 'haskell',
     locale: 'en',
     exercises: [
         {type: 'problem',
          name: 'Bar',
          description: 'a description',
          test: 'foo bar',
          tag_list: %w(baz bar),
          layout: 'no_editor',
          id: 1},

         {type: 'playground',
          description: 'lorem ipsum',
          name: 'Foo',
          tag_list: %w(foo bar),
          id: 4},

         {name: 'Baz',
          description: 'lorem ipsum',
          tag_list: %w(baz bar),
          layout: 'editor_bottom',
          type: 'problem',
          expectations: [{inspection: 'HasBinding', binding: 'foo'}],
          id: 2}]}.deep_stringify_keys
  end

  describe '#import_from_json!' do
    context 'when guide is empty' do
      let!(:haskell) { create(:haskell) }
      let(:guide) { create(:guide, exercises: []) }

      before do
        guide.import_from_json!(guide_json)
        guide.reload
      end

      it { expect(guide).to_not be nil }
      it { expect(guide.name).to eq 'sample guide' }
      it { expect(guide.language).to eq haskell }
      it { expect(guide.slug).to eq 'mumuki/sample-guide' }
      it { expect(guide.description).to eq 'Baz' }
      it { expect(guide.friendly_name).to include 'sample-guide' }

      it { expect(guide.exercises.count).to eq 3 }
      it { expect(guide.exercises.first.language).to eq haskell }
      it { expect(guide.exercises.first.friendly_name).to include 'sample-guide-bar' }

      it { expect(guide.exercises.last.expectations.first['binding']).to eq 'foo' }

      it { expect(guide.exercises.pluck(:name)).to eq %W(Bar Foo Baz) }
    end
    context 'when exercise already exists with bibliotheca_id' do
      let(:guide) { create(:guide, language: language, exercises: [exercise_1]) }

      before do
        guide.import_from_json! guide_json
        guide.reload
      end

      context 'when exercise changes its type' do
        let(:exercise_1) { create(:exercise,
                                  bibliotheca_id: 1,
                                  language: language,
                                  name: 'Exercise 1',
                                  description: 'description',
                                  test: 'test',
                                  corollary: 'A corollary',
                                  hint: 'baz',
                                  extra: 'foo',
                                  type: 'playground') }

        describe 'exercises are not duplicated' do
          it { expect(guide.exercises.count).to eq 3 }
          it { expect(Exercise.count).to eq 3 }
        end

        it { expect(guide.exercises.first).to eq be_instance_of(Playground) }
        it { expect(guide.exercises.first).to eq exercise_1 }

      end
      context 'exercises are reordered' do
        let(:exercise_1) { create(:exercise,
                                  bibliotheca_id: 4,
                                  language: language,
                                  name: 'Exercise 1',
                                  description: 'description',
                                  test: 'test',
                                  corollary: 'A corollary',
                                  hint: 'baz',
                                  extra: 'foo',
                                  type: 'playground') }

        it 'identity should be preserved' do
          expect(guide.exercises.second).to eq exercise_1
        end

        describe 'exercises are not duplicated' do
          it { expect(guide.exercises.count).to eq 3 }
          it { expect(Exercise.count).to eq 3 }
        end
      end
    end
    context 'when exercise already exists without bibliotheca_id' do
      let(:guide) { create(:guide, language: language, exercises: [exercise_1]) }

      context 'when exercise changes its type' do
        let(:exercise_1) { create(:exercise,
                                  language: language,
                                  name: 'Exercise 1',
                                  description: 'description',
                                  test: 'test',
                                  corollary: 'A corollary',
                                  type: 'playground',
                                  hint: 'baz',
                                  extra: 'foo') }

        before do
          guide.import_from_json! guide_json
          guide.reload
        end

        describe 'exercises are not duplicated' do
          it { expect(guide.exercises.count).to eq 3 }
          it { expect(Exercise.count).to eq 3 }
        end

        it { expect(guide.exercises.first).to be_instance_of(Playground) }
        it { expect(guide.exercises.first).to eq exercise_1 }
        it { expect(guide.exercises.pluck(:bibliotheca_id)).to eq [1, 4, 2] }
      end
      context 'when there are nil imported fields' do
        let(:exercise_1) { create(:exercise,
                                  language: language,
                                  name: 'Exercise 1',
                                  description: 'description',
                                  test: 'test',
                                  corollary: 'A corollary',
                                  type: 'playground',
                                  hint: 'baz',
                                  extra: 'foo') }
        let(:guide_json) { {
            'locale' => 'es',
            'language' => language.name,
            'exercises' => [
                {'name' => 'Exercise 2',
                 'description' => 'foo',
                 'test' => 'test',
                 'type' => 'problem',
                 'corollary' => nil,
                 'hint' => nil,
                 'extra' => nil,
                 'expectations' => []}]} }
        before do
          guide.import_from_json! guide_json
          guide.reload
        end

        it { expect(guide.exercises[0].name).to eq 'Exercise 2' }
        it { expect(guide.exercises[0].corollary).to be_blank }
        it { expect(guide.exercises[0].extra).to be_blank }
        it { expect(guide.exercises[0].hint).to be_blank }
        it { expect(guide.exercises[0].expectations).to be_blank }
      end
      context 'when missing imported fields' do
        let(:exercise_1) { create(:exercise,
                                  language: language,
                                  name: 'Exercise 1',
                                  description: 'description',
                                  test: 'test',
                                  corollary: 'A corollary',
                                  type: 'playground',
                                  hint: 'baz',
                                  extra: 'foo') }
        let(:guide_json) { {
            'locale' => 'es',
            'language' => language.name,
            'exercises' => [
                {'name' => 'Exercise 2',
                 'description' => 'foo',
                 'test' => 'test',
                 'id' => 1,
                 'type' => 'problem'}]} }

        before do
          guide.import_from_json! guide_json
          guide.reload
        end

        it { expect(guide.exercises[0].name).to eq 'Exercise 2' }
        it { expect(guide.exercises[0].corollary).to be_blank }
        it { expect(guide.exercises[0].extra).to be_blank }
        it { expect(guide.exercises[0].hint).to be_blank }
        it { expect(guide.exercises[0].expectations).to be_blank }
        it { expect(guide.exercises.pluck(:bibliotheca_id)).to eq [1] }

      end
    end
  end
end
