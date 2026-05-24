import { LightningElement } from 'lwc';

import getAccounts
from '@salesforce/apex/AccountController.getAccounts';

export default class AccountLoader extends LightningElement {

    accounts = [];

    loadAccounts() {

        getAccounts()

        .then(result => {

            this.accounts = result;

        })

        .catch(error => {

            console.error(error);

        });
    }
}