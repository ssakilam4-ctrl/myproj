import { LightningElement, track } from 'lwc';

export default class WeatherApp extends LightningElement {

    @track cityName = '';

    handleInputChange(event) {

        this.cityName = event.target.value;

        console.log('City Name => ', this.cityName);
    }

    handleWeatherSearch() {

        console.log('Search Button Clicked');

        console.log('Entered City => ', this.cityName);
    }
}