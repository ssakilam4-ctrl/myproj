import { LightningElement, track } from 'lwc';

import searchIndianPostalBranches
from '@salesforce/apex/SearchIndianPostalBranchesController.searchIndianPostalBranches';

export default class Lwc_searchIndianPostalBranches
extends LightningElement {

    @track postalPincode = '';

    @track branches = [];

    @track error;

    columns = [

        {
            label: 'Branch Name',
            fieldName: 'Name',
            type: 'text'
        },

        {
            label: 'Branch Type',
            fieldName: 'BranchType',
            type: 'text'
        },

        {
            label: 'Delivery Status',
            fieldName: 'DeliveryStatus',
            type: 'text'
        },

        {
            label: 'District',
            fieldName: 'District',
            type: 'text'
        },

        {
            label: 'State',
            fieldName: 'State',
            type: 'text'
        },

        {
            label: 'Pincode',
            fieldName: 'Pincode',
            type: 'text'
        }
    ];

    handleInputChange(event) {

        this.postalPincode = event.target.value;
    }

    handleSearch() {

        this.error = undefined;

        searchIndianPostalBranches({

            pinCode: this.postalPincode

        })

        .then(result => {

            this.branches = result;

            console.log('Branches => ', result);
        })

        .catch(error => {

            console.error(error);

            this.error =
                error.body.message;

            this.branches = [];
        });
    }
}