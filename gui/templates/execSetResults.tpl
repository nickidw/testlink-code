{* TestLink Open Source Project - http://testlink.sourceforge.net/ *}
{* $Id: execSetResults.tpl,v 1.16 2006/04/10 09:17:34 franciscom Exp $ *}
{* Purpose: smarty template - show tests to add results *}
{* Revisions:
*}	

{include file="inc_head.tpl" popup='yes'}

<body>

<h1>	
	<img alt="{lang_get s='help'}" class="help" 
	src="icons/sym_question.gif" style="float: right;"
	onclick="javascript:open_popup('{$helphref}execMain.html');" />
	{lang_get s='title_t_r_on_build'} {$build_name|escape} {lang_get s='title_t_r_owner'} ( {$owner|escape} )
</h1>

{* show echo about update if applicable *}
{$updated}

{* 20051108 - fm - BUGID 00082*}
{assign var="input_enabled_disabled" value="disabled"}
  	
<div id="main_content" class="workBack">
<form method='post'>
  {* -------------------------------------------------------------------------------------- *}
  {* 20060207 - franciscom - BUGID 303
     Added to make Test Results editable only if Current build is latest Build - Tools-R-Us *}
  {* 20051108 - fm - BUGID 00082*}
  {if $rightsEdit == "yes" and $edit_test_results == "yes"}
  	{assign var="input_enabled_disabled" value=""}
  	
	  <div class="groupBtn">
		  <input type="button" name="print" value="{lang_get s='btn_print'}" 
		         onclick="javascript:window.print();" />
  	</div>
	{/if}
	
	<hr />

	
	{foreach item=tc_exec from=$map_last_exec}
	
	  {assign var="tcversion_id" value=$tc_exec.id}
		<input type='hidden' name='tc_version[{$tcversion_id}]' value='{$tc_exec.testcase_id}' />
  	<h2>{lang_get s='th_test_case_id'}{$tc_exec.testcase_id} :: {lang_get s='title_test_case'} {$tc_exec.name|escape}</h2>

		<div id="execution_history" class="exec_history">
		<h3>{lang_get s='execution_history'}</h3>

	  {* -------------------------------------------------------------------------------------------------------- *}
    {* The very last execution for any build of this test plan                                                  *}
		{assign var="abs_last_exec" value=$map_last_exec_any_build.$tcversion_id}
    {if $abs_last_exec.status != '' and $abs_last_exec.status != $gsmarty_tc_status.not_run}			
      {assign var="status_code" value=$abs_last_exec.status}

			<div class="{$gsmarty_tc_status_css.$status_code}">
			{lang_get s='test_exec_last_run_date'} {localize_timestamp ts=$abs_last_exec.execution_ts}
			{lang_get s='test_exec_by'} {$abs_last_exec.tester_first_name|escape} {$abs_last_exec.tester_last_name|escape} 
			{lang_get s='test_exec_on_build'} {$abs_last_exec.build_name|escape}: 			
			{localize_tc_status s=$status_code}
			</div>
	    
		{else}
			<div class="not_run">{lang_get s='test_status_not_run'}</div>
			{lang_get s='tc_not_tested_yet'}
		{/if}
	  {* -------------------------------------------------------------------------------------------------------- *}

    {* -------------------------------------------------------------------------------------------------- *}
    {* 20060401 - franciscom*}
    {if $other_exec.$tcversion_id}
		  <table class="exec_history">
			 <tr>
				<th style="text-align:left">{lang_get s='date_time_run'}</th>
				<th style="text-align:left">{lang_get s='test_exec_by'}</th>
				<th style="text-align:left">{lang_get s='exec_status'}</th>
				<th style="text-align:left">{lang_get s='exec_notes'}</th>
			 </tr>
			{foreach item=tc_old_exec from=$other_exec.$tcversion_id}
 			<tr>
        <td>{localize_timestamp ts=$tc_old_exec.execution_ts}</td>
			  <td>{$tc_old_exec.tester_first_name|escape} {$tc_old_exec.tester_last_name|escape}</td> 
			  <td>{localize_tc_status s=$tc_old_exec.status}</td>
			  <td>{$tc_old_exec.execution_notes|escape}</td>
			</tr>  
			{/foreach}
			</table>
		{/if}
		{* -------------------------------------------------------------------------------------------------- *}
  </div> 

  <div>
		<table class="notesBox">
		<tr>
			<td colspan="2" class="title">{lang_get s='test_exec_summary'}</td>
		</tr>
		<tr>
			<td colspan="2">{$tc_exec.summary}</td>
		</tr>
		<tr>
			<td class="title" width="50%">{lang_get s='test_exec_steps'}</td>
			<td class="title" width="50%">{lang_get s='test_exec_expected_r'}</td>
		</tr>
		<tr>
			<td>{$tc_exec.steps}</td>
			<td>{$tc_exec.expected_results}</td>
		</tr>
		</table>

		<table border="2">
		<tr>
			<td rowspan="2">
				<div class="title">{lang_get s='test_exec_notes'}</div>
				<textarea {$input_enabled_disabled} class="tcDesc" name='notes[{$tcversion_id}]' 
					cols=50 rows=10></textarea>			
			</td>
			<td>			
  				{* status of test *}
  				<!-- <span class="title">{lang_get s='test_exec_result'}</span><br /> --->
  				<div class="title" style="text-align: center;">{lang_get s='test_exec_result'}</div>
  				
  				<div class="resultBox">
  					
  						<input type="radio" {$input_enabled_disabled} name='status[{$tcversion_id}]' 
  							value="{$gsmarty_tc_status.not_run}" checked="checked" />{lang_get s='test_status_not_run'}<br />
  						<input type="radio" {$input_enabled_disabled} name='status[{$tcversion_id}]' 
  							value="{$gsmarty_tc_status.passed}" />{lang_get s='test_status_passed'}<br />
  						<input type="radio" {$input_enabled_disabled} name='status[{$tcversion_id}]' 
  							value="{$gsmarty_tc_status.failed}" />{lang_get s='test_status_failed'}<br />
  						<input type="radio" {$input_enabled_disabled} name='status[{$tcversion_id}]' 
  							value="{$gsmarty_tc_status.blocked}" />{lang_get s='test_status_blocked'}<br />
  					<br>		
  		 			<input type='submit' name='save_results[{$tcversion_id}]' value="{lang_get s='btn_save_tc_exec_results'}" />
  				</div>
  			</td>
  	</tr>
	 </tr>
	</table>



	<hr />
	{/foreach}
</form>
</div>

</body>
</html>