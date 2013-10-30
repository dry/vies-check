Vies Check
==========

An Erlang library to perform country code and VAT number requests against the VIES SOAP service

Usage
-----

The only exported function is vies_check:request. It's specification is

```erlang
vies_check:request(CountryCode::string(), VatNumber::string() [, Format::format()])
```

where the format type is

```erlang
atom() :: raw | proplist | json
```

