<#-- Author : issacucumber -->
<#-- common_utils macro : common methods like json_encode, json_decode... -->

<#-- library COMMON_UTILS -->

<#function parseResponse status errorCode returnObject>
	<#return {"status" : status, "errorCode" : errorCode, "object" : returnObject }>
</#function>

<#function parseJSON json>
	<#if json??>
    	<#assign json_input = json?replace("\\u", "\\\\u") />
		<#assign json_input = json?replace("null", "\"\"") />
		<#return json_input?eval>
	<#else>
		<#return {}>
	</#if>
</#function>

<#function validateEmail email>
	<#return email?? && email?matches(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9]{2,63}$)")>
</#function>

<#function validateIC ic>
	<#return ic?? && ic?matches(r"(^[a-zA-Z0-9]{9,13})")>
</#function>

<#function isNotNull data> <#-- response but be an object/ a hash -->
	<#return data?has_content && data?? && !data?is_string >
</#function>

<#function fn_json_encode input_obj><#-- return json string -->
   <#assign response_str = "" />
   <#if !input_obj?? >
		<#assign response_str = response_str + "\"" + null + "\"" /> 
   <#elseif input_obj?is_hash >
  	<#local hash_keys = input_obj?keys />
    <#local hash_keys_count = input_obj?size />
    <#local counter = 1 />
  	<#list hash_keys as _key>
      <#if counter == 1 >
		<#assign response_str = response_str + "{" />
      </#if>
		<#assign response_str = response_str + "\"" + _key + "\":" + fn_json_encode(input_obj[_key]) />
      <#if counter < hash_keys_count >
		<#assign response_str = response_str + "," />
      </#if>
      <#if counter == hash_keys_count >
		<#assign response_str = response_str + "}" />
      </#if>
      <#local counter = counter + 1 />
  	</#list>
  <#elseif input_obj?is_sequence >
	<#local sequence_count = input_obj?size />
	<#if sequence_count == 0>
		<#assign response_str = response_str + "[]" />
    <#else>
    <#local seq_counter = 1 />
  	<#list input_obj as _obj>
      <#if seq_counter == 1 >
		<#assign response_str = response_str + "[" />
      </#if>
	  <#assign response_str = response_str + fn_json_encode(_obj) />
      <#if seq_counter < sequence_count >
		<#assign response_str = response_str + "," />  
      </#if>
      <#if seq_counter == sequence_count >
		<#assign response_str = response_str + "]" />  
      </#if>
      <#local seq_counter = seq_counter + 1 />
  	</#list>
	</#if>
	<#elseif input_obj?is_boolean >
	   <#assign response_str = response_str + "\"" + input_obj?string("true", "false") + "\"" /> 
  <#else>
	<#assign response_str = response_str + "\"" + input_obj + "\"" />
  </#if>

  <#return response_str>
</#function>
  
<#macro json_encode input_obj><#-- echo the json string directly -->
<@compress single_line=true>
  <#assign response_str = "" />
  <#if input_obj?is_hash >
  	<#local hash_keys = input_obj?keys />
    <#local hash_keys_count = input_obj?size />
    <#local counter = 1 />
  	<#list hash_keys as _key>
      <#if counter == 1 >
${"{"}
      </#if>
${"\"" + _key + "\":"}
      <@json_encode input_obj = input_obj[_key] />
      <#if counter < hash_keys_count >
${","}
      </#if>
      <#if counter == hash_keys_count >
${"}"}
      </#if>
      <#local counter = counter + 1 />
  	</#list>
  <#elseif input_obj?is_sequence >
	<#local sequence_count = input_obj?size />
	<#if sequence_count == 0>
		${"[]"}
    <#else>
    <#local seq_counter = 1 />
  	<#list input_obj as _obj>
      <#if seq_counter == 1 >
${"["}
      </#if>
      <@json_encode input_obj=_obj />
      <#if seq_counter < sequence_count >
${","}  
      </#if>
      <#if seq_counter == sequence_count >
${"]"}
      </#if>
      <#local seq_counter = seq_counter + 1 />
  	</#list>
	</#if>
	<#elseif input_obj?is_boolean >
	${"\"" + input_obj?string("true", "false") + "\""}
  <#else>
${"\"" + input_obj + "\""}
  </#if>
</@compress>
</#macro>