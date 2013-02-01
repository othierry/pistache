exports.config =
  # See http://brunch.readthedocs.org/en/latest/config.html for documentation.
  paths:
    public: 'build'
  files:
    javascripts:
      joinTo:
        'lib/pistache.js': /^app/
        'lib/pistache-vendor.js': /^vendor/
        'test/test.js': /^test(\/|\\)(?!vendor)/
        'test/test-vendor.js': /^test(\/|\\)(?=vendor)/
