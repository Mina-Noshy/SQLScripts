sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO
-- Create a Database Mail profile  
EXECUTE msdb.dbo.sysmail_add_profile_sp  
    @profile_name = 'FMNotifications',  
    @description = 'Profile used for sending outgoing notifications using Gmail.' ;  
GO

-- Grant access to the profile to the DBMailUsers role  
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
    @profile_name = 'FMNotifications',  
    @principal_name = 'public',  
    @is_default = 1 ;
GO

-- Create a Database Mail account  
EXECUTE msdb.dbo.sysmail_add_account_sp  
    @account_name = 'FMmail',  
    @description = 'Mail account for sending outgoing notifications.',  
    @email_address = 'name@gmail.com',  
    @display_name = 'Royal Comfort',  
    @mailserver_name = 'smtp.gmail.com',
    @port = 587,
    @enable_ssl = 1,
    @username = 'name@gmail.com',
    @password = 'p@ssword' ;  
GO

-- Add the account to the profile  
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp  
    @profile_name = 'FMNotifications',  
    @account_name = 'FMmail',  
    @sequence_number =1 ;  
GO

--To delete profiler use next comment;
--EXECUTE msdb.dbo.sysmail_delete_profileaccount_sp @profile_name = 'FMNotifications'
--EXECUTE msdb.dbo.sysmail_delete_principalprofile_sp @profile_name = 'FMNotifications'
--EXECUTE msdb.dbo.sysmail_delete_account_sp @account_name = 'FMmail'
--EXECUTE msdb.dbo.sysmail_delete_profile_sp @profile_name = 'FMNotifications'

exec msdb.dbo.sp_send_dbmail @profile_name='FMNotifications',@recipients='name@gmail.com',@subject='Any Subject',@body='Test Email....!'; --,@body_format ='HTML';
select sent_status,* from msdb..sysmail_allitems order by mailitem_id desc;