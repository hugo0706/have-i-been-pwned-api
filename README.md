# HaveIBeenPwnedApi
[![CI](https://github.com/hugo0706/have-i-been-pwned-api/actions/workflows/main.yml/badge.svg)](https://github.com/hugo0706/have-i-been-pwned-api/actions/workflows/main.yml)
[![codecov](https://codecov.io/gh/hugo0706/have-i-been-pwned-api/branch/main/graph/badge.svg?token=LX044H2DY5)](https://codecov.io/gh/hugo0706/have-i-been-pwned-api)
[![Gem Version](https://badge.fury.io/rb/have_i_been_pwned_api.svg)](https://badge.fury.io/rb/have_i_been_pwned_api)

A simple ruby wrapper for [Have I Been Pwned v3 API](https://haveibeenpwned.com/API/v3).

It simplifies the interaction with all the endpoints included in version 3 of their API.

# Installation
Install the gem and add to the application's Gemfile by executing:

```bash
bundle add 'have_i_been_pwned_api'
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install 'have_i_been_pwned_api'
```

# Setup

First configure the API client on an initializer, you can either use a default setup or configure your own.
You can configure the follwing optional parameters of the gem:
| Parameter      | Required  | Type      | Description |
|----------------|-----------|-----------|-------------|
| `api_key`      | `False`   | `String`  | Required only if using other than [PwnedPassword endpoints](#pwned-passwords) |
| `user_agent`   | `False`   | `String`  | User agent used on requests to API. Required by HIBP. Defaults to `"have_i_been_pwned_api gem [current gem version]"` |

```ruby
# If you only want access to pwdned passwords endpoint and default config
HaveIBeenPwnedApi.configure

# If you want to specify your api key and user agent
HaveIBeenPwnedApi.configure do |config|
  config.api_key = ENV['HIBP_API_KEY']
  config.user_agent = "your_custom_user_agent"
end
```

# Free endpoints

## Pwned Passwords
The usage of this endpoint does not require a HIBP key configured, but it can be used also if you have one.

This API endpoint returns the total times a given password has been pwned. It returns `0` whenever it has not been pwned.

It protects the value of queried passwords by using k-Anonymity model, which allows a password to be searched for by using only a partial hash. You can read more about k-anonimity [here](https://www.troyhunt.com/ive-just-launched-pwned-passwords-version-2/)

| Parameter      | Required  | Type      | Description |
|----------------|-----------|-----------|-------------|
| `password`       | `True`   | `String`  | (e.g. `"password"`) Represents the password searched for |
```ruby
HaveIBeenPwnedApi::PwnedPasswords.check_pwd(password: "your-password")
# => 1724
# Returns 0 if the password has not been compromised
# otherwise returns the total amount of times it has been compromised
```

# Premium endpoints
The usage of the following endpoints requires a HIBP api key configured.
## > Breaches Endpoints
### Latest breach
This API returns the most recently added breach based on the `"AddedDate"` attribute of the breach model. This may not be the most recent breach to occur as there may be significant lead time between a service being breached and the data later appearing on HIBP.
```ruby
latest_breach = HaveIBeenPwnedApi::Breaches.latest_breach
# Returns an instance of HaveIBeenPwnedApi::Models::Breach
latest_breach.class
=> HaveIBeenPwnedApi::Models::Breach
latest_breach.name
=> "SamsungGermany"
```
See more about the [Breach model](#breach) and how to access its values in Models section

### Breaches
This API endpoint returns the details of each of the breaches in the system stored in a `BreachCollection`
```ruby
# Returns an instance of HaveIBeenPwnedApi::Models::BreachCollection
collection = HaveIBeenPwnedApi::Breaches.breaches
collection.breaches.class
# => HaveIBeenPwnedApi::Models::BreachCollection
collection.breaches.count
# => 882
```
See more about [BreachCollection model](#breachcollection) and how to access its values in Models section

You can pass optional keyword arguments to narrow down the returned set:

| Parameter      | Required  | Type      | Description |
|----------------|-----------|-----------|-------------|
| `domain`       | `False`   | `String`  | (e.g. `"adobe.com"`) Filters the result set to only breaches against the domain specified. It is possible that one site (and consequently domain), is compromised on multiple occasions. |
| `is_spam_list` | `False`   | `Boolean` | Filters the result set to only breaches that either are or are not flagged as a spam list. |

```ruby
# Fetch only breaches against adobe.com that are flagged as spam list
collection = HaveIBeenPwnedApi::Breaches.breaches(domain: "adobe.com", is_spam_list: true)
```

### Breached Account
This API endpoint returns a list of all breaches a particular account has been involved in. The API requires a single parameter which is the account to be searched for.
| Parameter      | Required  | Type      | Description |
|----------------|-----------|-----------|-------------|
| `account`       | `True`   | `String`  | (e.g. `"email@mail.com"`) Not case-sensitive. Represents the account searched for |
| `truncate_response` | `False`   | `Boolean`  | Default `true`. By default reduces the size of responses by 98% returning a collection of TruncatedBreach. If set to `false` it will return a collection of full Breach objects  |
 `domain` | `False`   | `string`  | e.g. `"adobe.com"`) Filters the result set to only breaches against the domain specified. It is possible that one site (and consequently domain), is compromised on multiple occasions.  |
  `include_unverified` | `False`   | `Boolean`  | Returns breaches that have been flagged as "unverified". By default, both verified and unverified breaches are returned when performing a search |
```ruby
# By default returns a BreachCollection of TruncatedBreaches
collection = HaveIBeenPwnedApi::Breaches.breached_account(account: "mail@gmail.com")
# => #<HaveIBeenPwnedApi::Models::BreachCollection
collection.breaches.first.class
# => HaveIBeenPwnedApi::Models::TruncatedBreach
```
If no breach is found an empty BreachCollection is returned
```ruby
<HaveIBeenPwnedApi::Models::BreachCollection @breaches=[]>
```
If you set `truncate_response` to `false`, you will get a collection of full breach models.
```ruby
collection = HaveIBeenPwnedApi::Breaches.breached_account(account: "mail@gmail.com",
                                                          truncate_response: false,
                                                          domain: "example.com", include_unverified: false))
# => #<HaveIBeenPwnedApi::Models::BreachCollection
collection.breaches.first.class
# => HaveIBeenPwnedApi::Models::Breach
```

### Breached Domain
This API returns email addresses on a given domain and the breaches they've appeared in. Only domains that have been successfully added to [your domain search dashboard](https://haveibeenpwned.com/DomainSearch) will be returned.
```ruby
# Returns a HaveIBeenPwnedApi::Models::BreachedDomain object
breached_domain = HaveIBeenPwnedApi::Breaches.breached_domain(domain: "mydomain.com")
# => HaveIBeenPwnedApi::Models::BreachedDomain
breached_domain.entries.count
# => 2
```
If it does not find a breach for the given domain, an empty BreachedDomain object is returned
```ruby
<HaveIBeenPwnedApi::Models::BreachedDomain @entries={}>
```
See more about the [BreachedDomain model](#breacheddomain) and how to access its values in Models section

### Data Classes
This API returns the full list of breached data classes as an ordered array of strings. Each string represents an attribute of records compromised on a breach. For example `"Email addresses"` and `"Passwords"`
```ruby
HaveIBeenPwnedApi::Breaches.data_classes
# => 
# ["Account balances",
#  "Address book contacts",
#  "Age groups",
#  ...]
```

### Subscribed Domains
Domains that have been successfully added to [your domain search dashboard](https://haveibeenpwned.com/DomainSearch) are returned via this API.
```ruby
# Returns an array of Domain objects
domains = HaveIBeenPwnedApi::Breaches.subscribed_domains
# =>
# [#<HaveIBeenPwnedApi::Models::Domain,
#   ...] 
```
See more about the [Domain model](#domain) and how to access its values in Models section

---
## > Pastes Endpoints
### Paste Account
Returns all the `Pastes` where a given account is present, stored on a `PasteCollection` object. Takes a single parameter which is the email address to be searched for.
| Parameter      | Required  | Type      | Description |
|----------------|-----------|-----------|-------------|
| `account`       | `True`   | `String`  | (e.g. `"email@mail.com"`) Not case-sensitive. Represents the account searched for |
```ruby
paste_collection = HaveIBeenPwnedApi::Pastes.paste_account(account: "test@gmail.com")
=> 
#<HaveIBeenPwnedApi::Models::PasteCollection
```
See more about the [PasteCollection model](#pastecollection) and how to access its values in Models section

---
## > Stealer Logs Endpoints
All stealer log APIs [require a Pwned 5 subscription or higher](https://haveibeenpwned.com/API/Key), regardless of domain size. Each search can only be performed against domains that have been successfully added to [your domain search dashboard](https://haveibeenpwned.com/DomainSearch).

### By email
This API returns an array of domains where the given email and password where captured by an infostealer.
| Parameter      | Required  | Type      | Description |
|----------------|-----------|-----------|-------------|
| `email`       | `True`   | `String`  | (e.g. `"email@mail.com"`) Not case-sensitive. Represents the account searched for |
```ruby
domains = HaveIBeenPwnedApi::StealerLogs.by_email(email: 'mail@mydomain.com')
# => ["netflix.com", "spotify.com"]
```

### By domain
This API returns an array of emails that have been captured by an infostealer on the given domain.
| Parameter      | Required  | Type      | Description |
|----------------|-----------|-----------|-------------|
| `domain`       | `True`   | `String`  | (e.g. `"mydomain.com"`) Represents the domain searched for |
```ruby
emails = HaveIBeenPwnedApi::StealerLogs.by_website_domain(domain: 'fiestup.com')
# => ["andy@mydomain.com", "jane@mydomain.com"]
```

### By Email Domain
This API returns stealer log data  by the domain of the email address.
| Parameter      | Required  | Type      | Description |
|----------------|-----------|-----------|-------------|
| `domain`       | `True`   | `String`  | (e.g. `"mydomain.com"`) Represents the domain searched for |
```ruby
emails = HaveIBeenPwnedApi::StealerLogs.by_email_domain(domain: 'fiestup.com')
# => {"andy"=>["netflix.com"], "jane"=>["netflix.com", "spotify.com"]}
```


---
## > Subscription Endpoints
### Status
This API returns details of the current subscription
```ruby
HaveIBeenPwnedApi::Subscription.status
# => 
# #<HaveIBeenPwnedApi::Models::SubscriptionStatus
#  @description="Domains with up to 25 breached addresses each, and a rate limited API key allowing 10 email address searches per minute",
#  @domain_search_max_breached_accounts=25,
#  @rpm=10,
#  @subscribed_until=#<DateTime: 2025-05-18T11:52:59+00:00 ((2460814j,42779s,0n),+0s,2299161j)>,
#  @subscription_name="Pwned 1">
```
See more about [SubsctiptionStatus model](#subscriptionstatus) and how to access its values in Models section

---
# Models
### BreachCollection
A wrapper around an array of `Breach` or `TruncatedBreach` objects. Includes `Enumerable` so you can iterate, filter, and query like a standard Ruby collection.

#### Attribute readers

- **`breaches`** (`Array<HaveIBeenPwnedApi::Models::Breach` or `TruncatedBreach>`): the list of breach models in this collection

---
### Breach
Represents the full details of a single breach returned by the Have I Been Pwned API.

#### Example
```ruby
<HaveIBeenPwnedApi::Models::Breach
 @added_date=#<DateTime: 2025-04-13T00:24:36+00:00 ((2460779j,1476s,0n),+0s,2299161j)>,
 @breach_date=#<Date: 2025-03-30 ((2460765j,0s,0n),+0s,2299161j)>,
 @data_classes=["Email addresses", "Names", "Physical addresses", "Purchases", "Salutations", "Shipment tracking numbers", "Support tickets"],
 @description=
  "In March 2025, <a href=\"https://www.infostealers.com/article/samsung-tickets-data-leak-infostealers-strike-again-in-massive-free-dump/\" target=\"_blank\" rel=\"noopener\">data from Samsung Germany was compromised in a data breach of their logistics provider, Spectos</a>. Allegedly due to credentials being obtained by malware running on a Spectos employee's machine, the breach included 216k unique email addresses along with names, physical addresses, items purchased from Samsung Germany and related support tickets and shipping tracking numbers.",
 @domain="samsung.de",
 @is_fabricated=false,
 @is_malware=false,
 @is_retired=false,
 @is_sensitive=false,
 @is_spam_list=false,
 @is_stealer_log=false,
 @is_subscription_free=false,
 @is_verified=true,
 @logo_path="https://haveibeenpwned.com/Content/Images/PwnedLogos/Samsung.png",
 @modified_date=#<DateTime: 2025-04-13T12:42:28+00:00 ((2460779j,45748s,0n),+0s,2299161j)>,
 @name="SamsungGermany",
 @pwn_count=216333,
 @title="Samsung Germany Customer Tickets">
```

#### Attribute readers

- **`name`** (`String`): Internal, Pascal-cased unique breach identifier.
- **`title`** (`String`): User-friendly breach title .
- **`domain`** (`String`): Primary website domain where the breach occurred.
- **`breach_date`** (`Date`): Date the breach happened.
- **`added_date`** (`DateTime`): When the breach was added to HIBP.
- **`modified_date`** (`DateTime`): Last time the breach record was updated.
- **`pwn_count`** (`Integer`): Number of accounts loaded into the system for this breach.
- **`description`** (`String`): HTML overview of the incident (may include links, formatting).
- **`data_classes`** (`Array<String>`): List of data types compromised (e.g. `"Email addresses"`, `"Passwords"`, etc.).
- **Boolean flags** (`true`/`false`):
  - `is_verified`
  - `is_fabricated`
  - `is_sensitive`
  - `is_retired`
  - `is_spam_list`
  - `is_malware`
  - `is_subscription_free`
  - `is_stealer_log`
  Indicate special breach characteristics (verified, fabricated, sensitive, etc.).  
- **`logo_path`** (`String`): URL to the breach’s PNG logo.  

---
### TruncatedBreach
A simplified Breach model used when only breach names are returned (e.g. truncated responses).

#### Attribute readers

- **`name`** (`String`): Pascal-cased breach identifier (same as the `Name` field in the API).

---
### BreachedDomain
Represents the result of a domain-scoped breach lookup, where each email alias is mapped to the list of breach names in which it appears.

#### Example
```ruby
<HaveIBeenPwnedApi::Models::BreachedDomain @entries={"alias1"=>["Adobe"], "alias2"=>["Adobe", "Gawker", "Stratfor"], "alias3"=>["AshleyMadison"]}>
```

#### Attribute readers

- **`entries`** (`Hash<String, Array<String>>`):  
  A hash mapping each email local-part (e.g. `"alias1"` for `alias1@example.com`) to an array of Pascal-cased breach names:  
```ruby
{
  "alias1" => ["Adobe"],
  "alias2" => ["Adobe", "Gawker", "Stratfor"],
  "alias3" => ["AshleyMadison"]
}
```

---
### Domain

#### Attribute readers

- **`domain_name`** (`String`): The full domain name that has been successfully verified.
- **`pwn_count`** (`Integer` or `nil`): Total breached email addresses found on the domain at last search (null if no searches yet).
- **`pwn_count_excluding_spam_lists`** (`Integer` or `nil`): Same as `pwn_count`, excluding breaches flagged as spam lists (null if no searches yet).
- **`pwn_count_excluding_spam_lists_at_last_subscription_renewal`** (`Integer` or `nil`): `pwn_count_excluding_spam_lists` value locked in when the current subscription began (null if never subscribed).
- **`next_subscription_renewal`** (`DateTime` or `nil`): ISO 8601 timestamp when the current subscription ends (null if never subscribed).

---
### PasteCollection
A wrapper around an array of `Paste` objects returned by the paste-related endpoints. Includes `Enumerable` so you can iterate, filter, and query just like a standard Ruby collection.

#### Example
```ruby
<HaveIBeenPwnedApi::Models::PasteCollection
 @pastes=
  [#<HaveIBeenPwnedApi::Models::Paste @date=#<DateTime: 2016-06-22T11:06:26+00:00 ((2457562j,39986s,0n),+0s,2299161j)>, @domain=nil, @email_count=323, @id="Y8k3SJjg", @source="Pastebin", @title=nil>,
   #<HaveIBeenPwnedApi::Models::Paste @date=#<DateTime: 2016-02-18T15:51:55+00:00 ((2457437j,57115s,0n),+0s,2299161j)>, @domain=nil, @email_count=2225, @id="X1tzUFdD", @source="Pastebin", @title=nil>, ...
```

#### Attribute readers

- **`pastes`** (`Array<HaveIBeenPwnedApi::Models::Paste>`):  
  The underlying list of `Paste` instances.

---
### Paste
Represents a single paste record.

#### Example
```ruby
<HaveIBeenPwnedApi::Models::Paste @date=#<DateTime: 2014-03-04T19:14:54+00:00 ((2456721j,69294s,0n),+0s,2299161j)>, @domain=nil, @email_count=139, @id="8Q0BvKD8", @source="Pastebin", @title="syslog"
```

#### Attribute readers

- **`source`** (`String`): The service the paste came from (e.g. `"Pastebin"`, `"Ghostbin"`, `"JustPaste"`, etc.).  
- **`id`** (`String`): The identifier assigned by the source service (used, together with `source`, to build the paste URL).  
- **`title`** (`String` or `nil`): The paste’s title as shown on the source site (may be `nil` if none was provided).  
- **`date`** (`DateTime` or `nil`): Timestamp when the paste was posted (precision to the second; may be `nil` if unavailable).  
- **`email_count`** (`Integer`): Number of email addresses extracted from the paste.  

---
### SubscriptionStatus
Encapsulates your current subscription details and rate limits.

#### Example
```ruby
<HaveIBeenPwnedApi::Models::SubscriptionStatus
 @description="Domains with up to 25 breached addresses each, and a rate limited API key allowing 10 email address searches per minute",
 @domain_search_max_breached_accounts=25,
 @rpm=10,
 @subscribed_until=#<DateTime: 2025-05-18T11:52:59+00:00 ((2460814j,42779s,0n),+0s,2299161j)>,
 @subscription_name="Pwned 1">
```

#### Attribute readers

- **`description`** (`String`):  
  Human-readable summary of your subscription tier (e.g. `"Domains with up to 25 breached addresses each, and a rate limited API key allowing 10 email address searches per minute"`).

- **`domain_search_max_breached_accounts`** (`Integer`):  
  Maximum number of breached accounts returned per domain search (e.g. `25`).

- **`rpm`** (`Integer`):  
  Allowed email-search requests per minute (rate limit) (e.g. `10`).

- **`subscribed_until`** (`DateTime`):  
  ISO 8601 timestamp when your current subscription expires (e.g. `2025-05-18T11:52:59+00:00`).

- **`subscription_name`** (`String`):  
  The name of your subscription plan (e.g. `"Pwned 1"`).

## Errors

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hugo0706/have_i_been_pwned_api

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
