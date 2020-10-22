mumuki.load(() => {
  mumuki.kindergarten = {
    speak(selector, locale) {
      const msg = new SpeechSynthesisUtterance();
      msg.text = $(selector).text();
      msg.lang = locale.split('_')[0];
      msg.pitch = 0;
      window.speechSynthesis.speak(msg);
    },
    showContext() {
      mumuki.kids.showContext();
    },
    disablePlaySoundButtonIfNotSupported() {
      if (!window.speechSynthesis) {
        const $button = $('.mu-kindergarten-play-description')
        $button.prop('disabled', true);
        $button.css('cursor', 'not-allowed');
        $button.children('i').removeClass('fa-volume-up').addClass('fa-volume-off');
      }
    },
    toggleHint() {
      $('.mu-kindergarten-light-speech-bubble').toggleClass('open');
    },
    toggleHintMedia() {
      const $hintMedia = $('.mu-kindergarten-hint-media');
      const $i = $('.expand-or-collapse-hint-media').children('i');
      $i.toggleClass('fa-caret-up').toggleClass('fa-caret-down');
      $hintMedia.toggleClass('closed');
    },
    modal: {
      _activeSlideImage() {
        return $('.mu-kindergarten-context-image-slides').find('.active');
      },
      clickButton(prevOrNext) {
        this._activeSlideImage().removeClass('active')[prevOrNext]().addClass('active');
        this.showNextOrCloseButton();
        this.hidePreviousButtonIfFirstImage();
      },
      nextSlide() {
        this.clickButton('next');
      },
      prevSlide() {
        this.clickButton('prev');
      },
      showNextOrCloseButton() {
        const $next = $('.mu-kindergarten-modal-button.mu-next');
        const $close = $('.mu-kindergarten-modal-button.mu-close');
        if (this._activeSlideImage().is(':last-child')) {
          $next.addClass('hidden');
          $close.removeClass('hidden');
        } else {
          $close.addClass('hidden');
          $next.removeClass('hidden');
        }
      },
      hidePreviousButtonIfFirstImage() {
        const $prev = $('.mu-kindergarten-modal-button.mu-previous');
        if (this._activeSlideImage().is(':first-child')) {
          $prev.addClass('hidden');
        } else {
          $prev.removeClass('hidden');
        }
      }
    }
  };

  $(document).ready(() => {

    mumuki.resize(() => {
      mumuki.kids.scaleState($('.mu-kids-states'), 40);
      mumuki.kids.scaleBlocksArea($('.mu-kids-blocks'));
    })

    mumuki.kindergarten.disablePlaySoundButtonIfNotSupported();
    mumuki.kindergarten.modal.showNextOrCloseButton();

  })

});
