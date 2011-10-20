Pagination Component for Coldfusion
=====================

Config variables
=====================
* currentPage 
* perPage 
* totalItems 
* baseUrl 
* numLinks 

Template variables
=====================
* wrapperStart 
* wrapperEnd
* pageStart
* pageEnd
* previousStart
* previousEnd
* previousMark
* nextStart
* nextEnd
* nextMark
* activeStart
* activeEnd

Public Function
=====================
init
-----------------
#### optional argument
* config type struct  
* template type struct 


setConfig
-----------------
#### required argument
* config type struct  

setTemplate
-----------------
#### required argument
* Template type struct  

createLinks
-----------------

getOffset
-----------------

getPerPage
-----------------

Usage
=====================
<code>
&lt;cfparam name="currentPage" default="0"&gt;   
</code>  
<code>
&lt;cfif structKeyExists(url,'page')&gt;   
	&lt;cfset currentPage = url.page&gt;   
&lt;/cfif&gt; 
</code>  
<code>  
&lt;cfquery name="qCount" dataSource="myBlog"&gt;   
	SELECT COUNT(*) AS count FROM blog   
&lt;/cfquery&gt;  
</code>  
<code>
&lt;cfset config = structNew() &gt;  
&lt;cfset config.currentPage = variables.currentPage &gt;  
&lt;cfset config.totalItems = qCount.count &gt;  
&lt;cfset config.baseUrl = '#CGI.SCRIPT_NAME#?page=' &gt;
</code>  
<code>  
&lt;cfset obj = createObject('component','pagination').init(config)&gt;  
</code>  
<code>
&lt;cfquery name="posts" dataSource="myBlog"&gt;   
	SELECT * FROM blog LIMIT #pagi.getOffset#,#pagi.getPerPage()#  
&lt;/cfquery&gt; 
</code>  
<code>  
&lt;cfoutput&gt;    
my blog query output here   
&lt;/cfoutput&gt;  
&lt;cfoutput&gt;#obj.createLinks()&lt;/cfoutput&gt;
</code>









