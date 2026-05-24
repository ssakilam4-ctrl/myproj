global class UpdateContactsEmailServiceHelper implements Messaging.InboundEmailHandler
{
    global Messaging.InboundEmailResult handleInboundEmail(
        Messaging.InboundEmail email,
        Messaging.InboundEnvelope env
    )
    {
        Messaging.InboundEmailResult result =
            new Messaging.InboundEmailResult();

        List<Contact> contactRecords;

        try
        {
            contactRecords = new List<Contact>();

            contactRecords = [
                SELECT Id,
                       FirstName,
                       LastName,
                       Email,
                       Email_Subject__c,
                       Email_Content__c
                FROM Contact
                WHERE Email = :email.fromAddress
                LIMIT 1
            ];
        }
        catch(System.Exception ex)
        {
            System.debug(
                'Exception has been occured upon fetching the Record.'
            );

            System.debug(
                'Exception Message is....: ' +
                ex.getMessage()
            );

            System.debug(
                'Exception Line Number is....: ' +
                ex.getLineNumber()
            );

            System.debug(
                'Exception Root Cause is...: ' +
                ex.getCause()
            );

            System.debug(
                'Stack Trace String is....: ' +
                ex.getStackTraceString()
            );
        }

        // Check for Contact Record existence
        if(!contactRecords.isEmpty())
        {
            // Existing Contact found

            contactRecords[0].Email_Subject__c =
                email.subject;

            contactRecords[0].Email_Content__c =
                email.plainTextBody;
        }
        else
        {
            // No Contact found → create new Contact

            Contact contactRecord = new Contact();

            contactRecord.LastName =
                email.fromName;

            contactRecord.Email =
                email.fromAddress;

            contactRecord.Email_Subject__c =
                email.subject;

            contactRecord.Email_Content__c =
                email.plainTextBody;

            contactRecords.add(contactRecord);
        }

        upsert contactRecords;

        // Attachments Handling
        List<Attachment> lstAttachments =
            new List<Attachment>();

        // Text Attachments
        if(email.textAttachments != null)
        {
            for(
                Messaging.InboundEmail.TextAttachment txtAttachment
                : email.textAttachments
            )
            {
                Attachment attach =
                    new Attachment();

                attach.Body =
                    Blob.valueOf(txtAttachment.body);

                attach.Name =
                    txtAttachment.fileName;

                attach.ParentId =
                    contactRecords[0].Id;

                lstAttachments.add(attach);
            }
        }

        // Binary Attachments
        if(email.binaryAttachments != null)
        {
            for(
                Messaging.InboundEmail.BinaryAttachment bnrAttachment
                : email.binaryAttachments
            )
            {
                Attachment attach =
                    new Attachment();

                attach.Body =
                    bnrAttachment.body;

                attach.Name =
                    bnrAttachment.fileName;

                attach.ParentId =
                    contactRecords[0].Id;

                lstAttachments.add(attach);
            }
        }

        // Insert Attachments
        if(!lstAttachments.isEmpty())
        {
            insert lstAttachments;
        }

        // Send Result
        result.success = true;

        return result;
    }
}