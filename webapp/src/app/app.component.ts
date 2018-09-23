import {Component, ElementRef, OnInit} from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';

declare interface TableData {
  headerRow: string[];
  dataRows: any[];
}

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  private headersAdditional: HttpHeaders;
  public tableData1: TableData;
  private serverURL = 'http://35.230.188.187';

  constructor(private http: HttpClient) {
  }

  ngOnInit() {
    this.tableData1 = {
      headerRow: ['', 'NAME', 'Description', 'Rating', '# of Votes', 'Avg Price / Person'],
      dataRows: []
    };
    this.http.get(this.serverURL + '/restaurants').subscribe(
      (result) => {
        Object.keys(result).forEach(key => {
          const restaurant = result[key];
          console.log(restaurant.TD_account);
          this.tableData1.dataRows.push(
            {
              picture: 'card-1',
              name: restaurant.name,
              account: restaurant.TD_account,
              description: restaurant.description,
              stars: restaurant.rate,
              counts: restaurant.total,
              price: restaurant.price
            }
          );
          this.tableData1.dataRows.sort((a, b) => {
            if (a.stars > b.stars) { return -1; }
            else if (a.stars < b.stars) { return 1; }
            else return 0;
          });
        });
      });
  }
}
