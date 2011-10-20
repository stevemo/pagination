<cfcomponent displayname="Pagination" output="no" hint="Create pagination easy">
	
	<!-- ========================================================================= -->
	<!-- ! Template variable.. can be modify by the init function or setTemplate   -->
	<!-- ========================================================================= -->
	<cfset wrapperStart = '<div class="pagination"><ul>'>
	<cfset wrapperENd = '</ul></div>'>
	<cfset pageStart = '<li> '>
	<cfset pageEnd = ' </li>'>
	<cfset previousStart = '<li class="previous">'>
	<cfset previousEnd = '</li>'>
	<cfset previousMark = '&laquo; Previous'>
	<cfset nextStart = '<li class="next">'>
	<cfset nextEnd = '</li>'>
	<cfset nextMark = 'Next &raquo;'>
	<cfset activeStart = '<li><span class="active">'>
	<cfset activeEnd = '</span></li>'>

	<!-- ===================================================================================== -->
	<!-- ! Config variable Needed for calculation of Pagination set it via init or setConfig   -->
	<!-- ===================================================================================== -->
	<cfset currentPage = 0>
	<cfset perPage = 10>
	<cfset totalItems = 0>
	<cfset baseUrl = '#CGI.SCRIPT_NAME#?page='>
	<cfset numLinks = 5>
	
	<!-- ============================================= -->
	<!-- ! values generated from the config variable   -->
	<!-- ============================================= -->
	<cfset totalPages = 0>
	<cfset offset = 0>

	<!-- ============================================================================================================================ -->
	<!-- ! function init																										      -->
	<!--  Get the ball rolling baby 					  																			  -->
	<!-- ============================================================================================================================ -->
	<cffunction name="init" access="public" output="no" returnType="any">
		<cfargument name="config" type="struct" required="false">
		<cfargument name="template" type="struct" required="false">
		<cfscript>
			if(structKeyExists(arguments,'config'))
			{
				setConfig(arguments.config);
			}
			
			if(structKeyExists(arguments,'template'))
			{
				setTemplate(arguments.template);
			}
			return this;
		</cfscript>	
	</cffunction>

	<!-- ============================================================================================================================ -->
	<!-- ! function setConfig																										  -->
	<!--  pass the currentPage, perPage, totalItems, baseUrl and numlinks so we can create the pagination links 					  -->
	<!-- ============================================================================================================================ -->
	<cffunction name="setConfig" access="public" returnType="any" displayname="Set Config" hint="Setup the Component config variables" output="no">
		<cfargument name="config" type="struct" required="true">
		<cfscript>
			for(key in config)
			{
				if(key EQ 'currentPage' OR key EQ 'perPage' OR key EQ 'totalItems' OR key EQ 'baseUrl' OR key eq 'numLinks')
				{
					variables[key] = config[key];
				}		
			}
			
			initialize();
			return this;			
		</cfscript>
	</cffunction>

	<!-- ============================================================================================================================ -->
	<!-- ! function setTemplate																										  -->
	<!--  modify the preset value for the pagination style 																			  -->
	<!-- ============================================================================================================================ -->	
	<cffunction name="setTemplate" access="public" returnType="any" displayname="Set Template variables" hint="Setup the output style" output="no">
		<cfargument name="template" type="struct" required="true">
		<cfscript>
			for(key in template)
			{
				if( isDefined(key) )
				{
					variables[key] = template[key];
				}
			}

			return this;	
		</cfscript>
	</cffunction>
	
	<!-- ============================================================================================================================ -->
	<!-- ! function initialize																										  -->
	<!--  do all the calculation for the pagination creation 																		  -->
	<!-- ============================================================================================================================ -->
	<cffunction name="initialize" access="private" displayname="Initialize" hint="Do all the calculation for the pagination creation" output="no">
		<cfscript>
				
			variables.totalPages = ceiling(variables.totalItems / variables.perPage);
		
			if(variables.currentPage gt variables.totalPages)
			{
				variables.currentPage = variables.totalPages;
			}
			else if(variables.currentPage lt 1)
			{
				variables.currentPage = 1;
			}
			
			// The current page must be zero based so that the offset for page 1 is 0.
			variables.offset = (variables.currentPage - 1) * variables.perPage;
			return;
		</cfscript>
	</cffunction>

	<!-- ============================================================================================================================ -->
	<!-- ! function createLinks 																									  -->
	<!-- let's create some pagination links 																						  -->
	<!-- ============================================================================================================================ -->
	<cffunction name="createLinks" access="public" displayname="CreateLinks" hint="let's create some pagination links" output="no">
		<cfscript>
			var pagi = '';			
			// If our item count or per-page total is zero there is no need to continue.
			if(variables.totalPages eq 0)
			{
				return '';
			}	
			pagi &= variables.wrapperStart;
			pagi &= prevLink();
			pagi &= pageLinks();
			pagi &= nextLink();
			pagi &= variables.wrapperEnd;
			return pagi;
		</cfscript>
	</cffunction>
	
	<!-- ============================================================================================================================ -->
	<!-- ! function prevLink 																									      -->
	<!-- create the previous link if one needed																						  -->
	<!-- ============================================================================================================================ -->
	<cffunction name="prevLink" access="private" displayname="PrevLinks function" hint="generate the previous link" output="no">
		<cfscript>
			if(variables.totalPages eq 1 OR variables.currentPage eq 1)
			{
				return '';
			}
			else
			{
				var prev = variables.currentPage - 1;
				prev = (prev eq 1) ? '' : prev;
				return variables.previousStart & 
					'<a href="#variables.baseUrl##prev#">#variables.previousMark#</a>' & variables.previousEnd;
			}
		</cfscript>
	</cffunction>
	
	<!-- ============================================================================================================================ -->
	<!-- ! function nextLink 																									      -->
	<!-- create the next link if one needed																						      -->
	<!-- ============================================================================================================================ -->
	<cffunction name="nextLink" access="private" displayname="NextLink function" hint="Generate the next link" output="no">
		<cfscript>
			if(variables.totalPages eq 1 or (variables.currentPage eq variables.totalPages) )
			{
				return '';
			}
			else
			{
				var next = variables.currentPage + 1;
				return variables.nextStart & 
					'<a href="#variables.baseUrl##next#">#variables.nextMark#</a>' & variables.nextEnd;
			}
		</cfscript>
	</cffunction>

	<!-- ============================================================================================================================ -->
	<!-- ! function pageLinks 																									      -->
	<!-- create the number links																						              -->
	<!-- ============================================================================================================================ -->	
	<cffunction name="pageLinks" access="private" displayname="PageLinks function" hint="generate the number links" output="no">
		<cfscript>
			if(variables.totalPages eq 1)
			{
				return '';
			}
			
			var pagination = '';
			
			// Let's get the starting page number, this is determined using num_links
			var start = ( (variables.currentPage - variables.numLinks) gt 0 ) ? variables.currentPage - (variables.numLinks - 1) : 1;
			
			// Let's get the ending page number
			var end = ( (variables.currentPage + variables.numLinks) lt variables.totalPages ) ? variables.totalPages + variables.numLinks : variables.totalPages;
	
			for(i = start; i lte end; i++)
			{
				if(variables.currentPage eq i)
				{
					pagination &= variables.activeStart & i & variables.activeEnd;
				}
				else
				{
					var urls = (i eq 1) ? '' : i;
					pagination &= variables.pageStart & '<a href="#variables.baseUrl##urls#">#i#</a>' & variables.pageEnd;
				}
			}
		
			return pagination;
		</cfscript>
	</cffunction>

	<!-- ============================================================================================================================ -->
	<!-- ! function getOffset 																									      -->
	<!-- Retrieve the calculated offset																						          -->
	<!-- ============================================================================================================================ -->		
	<cffunction name="getOffset" access="public" displayname="GetOffset Function" hint="Retrieve the calculated offset" output="no">
		<cfreturn variables.offset>
	</cffunction>

	<!-- ============================================================================================================================ -->
	<!-- ! function getPerPage																									      -->
	<!-- Retrieve the perPage value																						              -->
	<!-- ============================================================================================================================ -->		
	<cffunction name="getPerPage" access="public" displayname="GetPerPage Function" hint="Retrieve the perPage value" output="no">
		<cfreturn variables.perPage>
	</cffunction>

</cfcomponent>

