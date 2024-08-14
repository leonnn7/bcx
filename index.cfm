<cfif NOT CGI.SERVER_PORT_SECURE>
	<cfif CGI.QUERY_STRING neq ''>
        <cflocation url="https://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" addtoken="no" />
    <cfelse>
        <cflocation url="https://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#" addtoken="no" />
    </cfif>
</cfif>
<cfinclude template="../inc_config.cfm">
<cfparam name="user" default="">
<cfparam name="pass" default="">

<cfquery name="Maske" datasource="FischliZunft">
  SELECT * FROM tblMaskenTexte WHERE mSeite='home' AND mSprache='DE';
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>KAKTUS CMS - Login</title>

<style>
body {background-image:url(img/login_bg.png); background-attachment:fixed; background-size:cover; font-family:arial; font-size:12px;}

#login_box {width:1000px; overflow:visible; position:absolute; top:35%; left:50%; margin-left:-450px;}
#login_logo {width:450px; height:141px; float:left; background-image:url(img/login_logo.png);}
#login_form {width:395px; height:96px; float:left; background-image:url(img/login_form.png); padding:45px 20px 0px 35px;}

#login_form label {float:left; margin:0px 5px 0px 0px;}
#login_form label input {padding:0px 5px; background:#fff; outline:solid 1px #333; border:none; height:18px;}

#loginmessage {background:#121212; padding:2px 8px; color:#f33; font-style:italic; font-weight:bold; font-size:11px;}
</style>

</head>

<body onload='javascript:document.getElementById("username").focus()'>
<cfset session.CMSAdmin = 0>
<cfset #loginmessage# = "">

<cfif #user# IS NOT "" AND Pass IS NOT "">

<cfset secWord = hash(pass, "SHA-256")>

<cfquery name="Webmaster" datasource="FischliZunft">
  SELECT AdrID, AdrStatus, EMail, Passwort 
  FROM tblAdressen
  WHERE AdrStatus = 1000
    AND <cfif ISNumeric(#user#)>(AdrID=#user#) OR (Vorname='#user#')<cfelse>Email='#user#'</cfif>
    AND Passwort='#secWord#';
</cfquery>

<cfif #Webmaster.Recordcount# GT 0>
  <cfset session.CMSAdmin = 5>
<cfelse>
  <cfset session.CMSAdmin = 3>
</cfif>

<cfif session.CMSAdmin GT 4>
<cflocation url="../index.cfm">
<cfelse>
<cfset #loginmessage# = "<label id='loginmessage'>#Maske.mText08#!</label>">
</cfif>

</cfif>

<!--LoginFields-->
<div id="login_box">
  <div id="login_logo"></div>
  <form id="login_form" action="" method="post">
    <cfoutput>
    <label>#Maske.mText05#: <br /><input type="text" name="user" id="username" required/></label> 
    <label>#Maske.mText06#: <br /><input type="password" name="pass" required/></label>
    <label>&nbsp;<br /><input type="submit" value="#Maske.mText07#" /></label>
    <div style="clear:both; margin-bottom:5px;"></div>
    #loginmessage#
	</cfoutput>
  </form>
</div id="loginbox">
<!--LoginFields-->

</body>
</html>