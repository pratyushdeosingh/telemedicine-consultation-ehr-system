# Final test evidence

Store dated test output and expected/actual results here. This folder currently contains no new test-run results.

Automated tests: from `backend`, run `npm test`. Frontend checks: from `frontend`, run `pnpm lint` and `pnpm build` using the documented runtime. These checks do not by themselves prove live Oracle/Cassandra connectivity.

For database integration checks, use the documented verification scripts in a suitable test environment and record which environment was checked. See `../../backend/package.json`. Do not run destructive schema setup on production.

Use a results table with columns: test ID, feature/action, synthetic input, expected result, actual result, pass/fail, evidence path. Cover five successful workflows plus invalid input, duplicate values, missing records, constraint rejection and transactional rollback. Include corresponding application/database screenshots in `../screenshots/`, with no credentials.
