import {Component, ElementRef, OnInit} from '@angular/core';
import {Subscription} from 'rxjs';
import {NavigationEnd, Router} from '@angular/router';

declare interface TableData {
  headerRow: string[];
  dataRows: string[][];
}

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  public tableData1: TableData;
  ngOnInit() {
    this.tableData1 = {
      headerRow: [ '', 'NAME', 'Ranking', 'Room', 'PRICE', 'QTY', 'AMOUNT'],
      dataRows: [
        ['card-2', '#jacket', 'Cozy 5 Stars Apartment', 'Barcelona, Spain', '5 stars', 'Standard Room', '899/night'],
        ['card-1', '#pants',  'Office Studio', 'London, UK', '4.5 stars', 'City View', '1119/night'],
        ['card-3', '#nothing', 'Beautiful Castle', 'Milan, Italy', '4 stars', 'Mountain View', '459/night']
      ]
    };
  }
  title = 'Norchain WebApp';
}
