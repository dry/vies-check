-module(vies_check).

-export([request/2,
	 request/3]).

-include_lib("xmerl/include/xmerl.hrl").

-define(ENDPOINT,
	"http://ec.europa.eu/taxation_customs/vies/services/checkVatService").

request(CountryCode, VatNumber) ->
    request(CountryCode, VatNumber, raw).

request(CountryCode, VatNumber, Format) ->
    Result = create_request(CountryCode, VatNumber),
    return(Result, Format).

create_request(CountryCode, VatNumber) ->
    {ok, Request} = request_dtl:render([{country_code, CountryCode},
					{vat_number, VatNumber}]),
    do_request(Request).

do_request(Request) ->
    Flattened = binary_to_list(list_to_binary(Request)),
    {ok, {Status, _, Response}} = httpc:request(post, {?ENDPOINT,
						       [],
						       ["text/xml"],
						       Flattened}, [], []),
    scan(Status, Response).

scan(_Status, Response) ->
    {Scanned, _Misc} = xmerl_scan:string(Response),
    
    [CountryCode] = xmerl_xpath:string("//checkVatResponse/countryCode/text()", Scanned),
    [VatNumber] = xmerl_xpath:string("//checkVatResponse/vatNumber/text()", Scanned),
    [Valid] = xmerl_xpath:string("//checkVatResponse/valid/text()", Scanned),
    [Name] = xmerl_xpath:string("//checkVatResponse/name/text()", Scanned),
    [Address] = xmerl_xpath:string("//checkVatResponse/address/text()", Scanned),

    [{country_code, CountryCode#xmlText.value},
     {vat_number, VatNumber#xmlText.value},
     {valid, Valid#xmlText.value},
     {name, Name#xmlText.value},
     {address, Address#xmlText.value}].

return(Result, raw) ->
    Result;
return(Result, proplist) ->
    [{Key, list_to_binary(Value)} || {Key, Value} <- Result];
return(Result, json) ->
    jsx:encode([{Key, list_to_binary(Value)} || {Key, Value} <- Result]).
