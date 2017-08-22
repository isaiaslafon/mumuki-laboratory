class Message < ActiveRecord::Base

  belongs_to :assignment, foreign_key: :submission_id, primary_key: :submission_id
  has_one :exercise, through: :assignment

  validates_presence_of :submission_id, :content, :sender

  markdown_on :content

  def notify!
    Mumukit::Nuntius.notify! 'student-messages', event_json
  end

  def event_json
    as_json(except: [:id, :type],
            include: {exercise: {only: [:bibliotheca_id]}})
      .merge(organization: Organization.current.name)
  end

  def read!
    update! read: true
  end

  def self.parse_json(json)
    message = json.delete 'message'
    json
      .except('uid', 'exercise_id')
      .merge(message)
  end

  def self.read_all!
    update_all read: true
  end

  def self.import_from_json!(json)
    message_data = parse_json json
    Organization.find_by!(name: message_data.delete('organization')).switch!

    if message_data['submission_id'].present?
      Assignment.find_by(submission_id: message_data.delete('submission_id'))&.receive_answer! message_data
    end
  end
end