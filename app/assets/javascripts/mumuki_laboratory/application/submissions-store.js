mumuki.SubmissionsStore = (() => {
  const SubmissionsStore = new class {
    /**
     * Returns the submission's result status for the last submission to
     * the given exercise, or pending, if not present
     *
     * @param {number} exerciseId
     * @returns {SubmissionStatus}
     */
    getLastSubmissionStatus(exerciseId) {
      const submission = this.getLastSubmissionAndResult(exerciseId);
      return submission ? submission.result.status : 'pending';
    }

    /**
     * Returns the submission and result for the last submission to
     * the given exercise
     *
     * @param {number} exerciseId
     * @returns {SubmissionAndResult}
     */
    getLastSubmissionAndResult(exerciseId) {
      const submissionAndResult = window.localStorage.getItem(this._keyFor(exerciseId));
      if (!submissionAndResult) return null;
      return JSON.parse(submissionAndResult);
    }

    /**
     * Saves the result for the given exercise
     *
     * @param {number} exerciseId
     * @param {SubmissionAndResult} submissionAndResult
     */
    setSubmissionResultFor(exerciseId, submissionAndResult) {
      window.localStorage.setItem(this._keyFor(exerciseId), this._asString(submissionAndResult));
    }

    /**
     * Retrieves the last cached, non-aborted result for the given submission of the given exercise
     *
     * @param {number} exerciseId
     * @param {Submission} submission
     * @returns {SubmissionResult} the cached result for this submission
     */
    getSubmissionResultFor(exerciseId, submission) {
      const last = this.getLastSubmissionAndResult(exerciseId);
      if (!last
          || last.result.status === 'aborted'
          || !this.submissionSolutionEquals(last.submission, submission)) {
        return null;
      }
      return last.result;
    }

     /**
     * Extract the submission's solution content
     *
     * @param {Submission} submission
     * @returns {string}
     */
    submissionSolutionContent(submission) {
      if (submission.solution) {
        return submission.solution.content;
      } else {
        return submission['solution[content]'];
      }
    }

    /**
     * Compares two solutions to determine if they are equivalent
     * from the point of view of the code evaluation
     *
     * @param {Submission} one
     * @param {Submission} other
     * @returns {boolean}
     */
    submissionSolutionEquals(one, other) {
      return this.submissionSolutionContent(one) === this.submissionSolutionContent(other);
    }

    // private API

    _asString(object) {
      return JSON.stringify(object);
    }

    _keyFor(exerciseId) {
      return `/exercise/${exerciseId}/submission`;
    }
  };

  return SubmissionsStore;
})();
