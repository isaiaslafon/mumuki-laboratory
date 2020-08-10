(() => {

  // ==========================
  // View function for building
  // the results UI
  // ==========================

  /**
   * @param {SubmissionStatus} status
   * @returns {string}
   */
  function iconForStatus(status) {
    switch (status) {
      case "errored":              return "fa-minus-circle";
      case "failed":               return "fa-times-circle";
      case "passed_with_warnings": return "fa-exclamation-circle";
      case "passed":               return "fa-check-circle";
      case "pending":              return "fa-circle";
    }
  }

  /**
   * @param {SubmissionStatus} status
   * @returns {string}
   */
  function classForStatus(status) {
    switch (status) {
      case "errored":              return "broken";
      case "failed":               return "danger";
      case "passed_with_warnings": return "warning";
      case "passed":               return "success";
      case "pending":              return "muted";
    }
  };


  /**
   * @param {SubmissionStatus} status
   * @param {boolean} [active]
   * @returns {string}
   */
  function progressListItemClassForStatus(status, active = false) {
    return `progress-list-item text-center ${classForStatus(status)} ${active ? 'active' : ''}`;
  };

  mumuki.renderers = mumuki.renderers || {};
  mumuki.renderers.classForStatus = classForStatus;
  mumuki.renderers.iconForStatus = iconForStatus;
  mumuki.renderers.progressListItemClassForStatus = progressListItemClassForStatus;
})();
