function myemail(subject,message,attachment)
if ~exist('message','var')
    message = 'Automatische Matlab Nachricht ohne Inhalt';
end
if ~exist('attachment','var')
    attachment = [];
end
    myaddress = 'wolfjulian.neumann@gmail.com';
    load(fullfile(getsystem,'gp'));
    gp = gp([12 16 125 24 28 32 37 2 48 54 62 69 1 61 8 95 31 45 116]);
    setpref('Internet','E_mail',myaddress);
    setpref('Internet','SMTP_Server','smtp.gmail.com');
    setpref('Internet','SMTP_Username',myaddress);
    setpref('Internet','SMTP_Password',gp);
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class', ...
                      'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');
    sendmail(myaddress, subject, message,attachment);