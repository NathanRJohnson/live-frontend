## Performing Migrations

1. Make updates
2. Bump schema version
3. `dart run drift_dev make-migrations`
4. update the `stepByStep` function with the migration steps
5. run `dart run build_runner build` so code completion works