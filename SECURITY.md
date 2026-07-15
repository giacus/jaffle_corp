# Security Policy

`jaffle-corp` is a fictional dbt fixture with synthetic data. It must not
contain credentials, private warehouse identifiers, production URLs, or real
customer, employee, vendor, or transaction data.

## Report Privately

If you find a vulnerability, secret, or sensitive material, do not open a
public issue. Submit a
[private security advisory](https://github.com/giacus/jaffle_corp/security/advisories/new)
with the affected file or behavior, potential impact, and safe reproduction
steps. Avoid including more sensitive data than the report needs.

Maintainers will acknowledge the report, investigate it, and coordinate any
public disclosure after the repository is safe.

## Contribution Rules

- Never commit credentials, tokens, `.env` files, or real connection details.
- Use only fictional, synthetic, and publication-safe data.
- Do not add private schema names, internal service names, or production URLs.
- Rotate any real secret immediately if it is committed, even if the commit is
  later removed.
