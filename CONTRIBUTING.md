# Contributing

Contributions to this project are [released](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license) to the public under the [project's open source license](LICENSE.md).

Everyone is welcome to contribute to Hubot. Contributing doesn’t just mean submitting pull requests—there are many different ways for you to get involved, including answering questions in [our community forum](https://forum.remote.it/) and reporting [issues](support@remote.it).

No matter how you want to get involved, we ask that you first learn what’s expected of anyone who participates in the project by reading the [Contributor Covenant Code of Conduct](http://contributor-covenant.org). By participating, you are expected to uphold this code.

We love pull requests. Here's a quick guide:

1. If you're adding a script, add it under the appropriate OS platform folder, named with a short logical name, and have appropriate comments in the script for documentation.
1. If you are improving a script, add appropriate comments in the script for documentation.
1. Fork the repo, and clone it locally.
1. Create a new branch for your contribution
1. Push to your fork and submit a pull request

At this point you're waiting on us. We like to at least comment on, if not
accept, pull requests within a few days. We may suggest some changes or improvements or alternatives.

Some things that will increase the chance that your pull request is accepted:

* Update the documentation: code comments, example code, guides. Basically,
  update everything affected by your contribution.
* Include any information that would be relevant to reproducing bugs, use cases for new features, etc.
* Discuss backwards compatibility
  * If the change does break compatibility, how can it be updated to become backwards compatible, while directing users to the new way of doing things?
* Your commits are associated with your GitHub user: https://help.github.com/articles/why-are-my-commits-linked-to-the-wrong-user/
* Make pull requests against a feature branch,
* Follow our commit message conventions:
  * use imperative, present tense: “change” not “changed” nor “changes”
  * Commit bug fixes with `fix: …` or `fix(scope): …` prefix
  * Commit features with `feat: …` or `feat(scope): …` prefix
  * Commit breaking changes by adding `BREAKING CHANGE:` in the commit body.
    The commit subject does not matter. A commit can have multiple `BREAKING CHANGE:`
    sections
  * Commit changes to README files or comments with `docs(README): …`
  * Cody style changes with `style: standard`
  * see [Angular’s Commit Message Conventions](https://gist.github.com/stephenparish/9941e89d80e2bc58a153)
    for a full list of recommendations.

# Stale issue and pull request policy

Issues and pull requests have a shelf life and sometimes they are no longer relevant. All issues and pull requests that have not had any activity for 90 days will be marked as `stale`. Simply leave a comment with information about why it may still be relevant to keep it open. If no activity occurs in the next 7 days, it will be automatically closed.

The goal of this process is to keep the list of open issues and pull requests focused on work that is actionable and important for the maintainers and the community.

# Pull Request Reviews & releasing

Once merged into the `master` branch, the change will automatically be available in the master branch with the commit messages of the pull request. 
