% % Modify these two lines to reflect
% % your account and password.
% myaddress = 'kylemath@gmail.com';
% mypassword = '#######';
% 
% setpref('Internet','E_mail',myaddress);
% setpref('Internet','SMTP_Server','smtp.gmail.com');
% setpref('Internet','SMTP_Username',myaddress);
% setpref('Internet','SMTP_Password',mypassword);
% 
% props = java.lang.System.getProperties;
% props.setProperty('mail.smtp.auth','true');
% props.setProperty('mail.smtp.socketFactory.class', ...
%                   'javax.net.ssl.SSLSocketFactory');
% props.setProperty('mail.smtp.socketFactory.port','465');
% 
% sendmail(myaddress, 'Gmail Test', 'This is a test message.');



ccc
names  = {'Bill'; 'Dick'; 'Barbra'};
emails = {'kylemath@gmail.com'; 'kmathew3@uiuc.edu'; 'kylemath@uvic.ca'};
tidbit = {'job interview'; 'game tonight'; 'presentation tomorrow'};
n_recp = size(names,1);

for i_recp = 1:n_recp
    
    message = ...
        ['Hello ' names{i_recp} ',' 10 ...
        'I hope this email finds you well, please find attached the document we spoke about. ' 10 ...
        10 ...
        'Thanks very much, and good luck with your ' tidbit{i_recp} '. ' 10 ...
        'Karl Marthewson' 10];
    
    sendmail(emails{i_recp},'Its Done here is the document!',message,'ccc.m')
end

