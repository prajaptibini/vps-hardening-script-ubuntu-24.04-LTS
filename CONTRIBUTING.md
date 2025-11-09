# Contributing to Ubuntu 24.04 Production Deploy

First off, thank you for considering contributing to this project! 🎉

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Description**: Clear description of the issue
- **Steps to Reproduce**: Detailed steps to reproduce the behavior
- **Expected Behavior**: What you expected to happen
- **Actual Behavior**: What actually happened
- **Environment**: 
  - Ubuntu version
  - Server provider (OVH, AWS, etc.)
  - Any relevant configuration
- **Logs**: Relevant log excerpts from `/var/log/vps_setup.log`

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear title and description**
- **Use case**: Why this enhancement would be useful
- **Possible implementation**: If you have ideas on how to implement it

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**
4. **Test thoroughly** on Ubuntu 24.04 LTS
5. **Commit your changes**: `git commit -m 'Add amazing feature'`
6. **Push to the branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**

## Development Guidelines

### Shell Script Standards

- Use `#!/bin/bash` shebang
- Enable strict mode: `set -e`
- Add comments for complex logic
- Use meaningful variable names
- Follow existing code style
- Test on clean Ubuntu 24.04 installation

### Testing

Before submitting a PR:

```bash
# Test script syntax
bash -n script.sh

# Run shellcheck (if available)
shellcheck script.sh

# Test on clean Ubuntu 24.04 VM
# Document test results in PR
```

### Commit Messages

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests

Example:
```
Add automatic backup script

- Implements daily backup to S3
- Configurable retention policy
- Email notifications on failure

Fixes #123
```

### Documentation

- Update README.md if adding features
- Update CHANGELOG.md following Keep a Changelog format
- Add comments in code for complex logic
- Update GUIDE.md if changing installation process

## Code Review Process

1. Maintainers will review your PR
2. Address any requested changes
3. Once approved, maintainers will merge

## Security

- Never commit sensitive data (passwords, keys, tokens)
- Report security vulnerabilities privately to maintainers
- Follow security best practices

## Questions?

Feel free to open an issue with the `question` label.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🚀
