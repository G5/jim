## Jim

This project was used to help determine if applications were configured correctly. It parsed a config file where you could define required and optional environment variables, validate them, and write a human-readable definition of what they were used for. It would also be called from code to determine which "features" of an application were properly configured, so you could conditionally enable certain features at runtime.

## Sunsetting

It's time for this perfectly-named repo to cross the rainbow bridge. No applications at G5 were actively using it, but it is installed in a few of them. It is not Rails 6 compatible and will never be. To remove the gem:

  * Remove it from your `Gemfile` and bundle
  * Remove `config/features.yml`, if it exists
  * Remove any `jim` references from `config/routes.rb`, if one exists
  * Search your codebase for `Jim` and modify things accordingly. You may find code like:
```ruby
Jim::FeatureManager.instance.add_dependency(
  :own_hostname,
  HtmlForm,
  "Finds and augments form markup for the form API. Generates an absolute URL for service consumers to hit to submit this form."
)
```

This can be removed completely. You may see code like:
```ruby
Jim::FeatureManager.enabled?(:own_hostname)
```
in that case, it was querying to see if the feature was configured properly. You'll want to change your code to stop using Jim and query the existence of environment variables yourself, or whatever is appropriate in your case to determine whether things are properly configured.
