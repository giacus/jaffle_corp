# Security

`jaffle-corp` is a fictional dbt demo with synthetic seed data. It should not contain secrets, credentials, private warehouse identifiers, or real business data.

If you find sensitive material in the repository, do not open a public issue with the details. Contact the maintainers privately through the repository security reporting flow.

When contributing:

- Do not commit credentials or `.env` files.
- Do not add real customer, employee, vendor, or transaction data.
- Do not add private schema names, production URLs, or internal service names.
- Run `scripts/check_sanitization.sh` with an appropriate `PROHIBITED_PATTERN` before publishing.

