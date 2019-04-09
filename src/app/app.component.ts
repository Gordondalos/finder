import { Component, OnInit } from '@angular/core';
import { DataService } from './data.service';
import { Info } from './Info.interfase';
import * as _ from 'lodash';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {

  myData: {
    start: string,
    finish: string,
    countOnStart: number,
    remainder: number,
    finSum: number,
    increment: number,
    key: string
  }[];
  info: Info;
  sum = 3000;
  type = 'increment';
  reverse = false;

  constructor(
    private dataService: DataService
  ) {
  }

  ngOnInit(): void {
    this.dataService.getData().subscribe((info: any) => {
      this.info = info;
      this.myData = this.normoliseData(info);
      console.log(this.myData);
    });
  }

  normoliseData(info: Info): Array<{
    start: string,
    finish: string,
    countOnStart: number,
    remainder: number,
    finSum: number,
    increment: number,
    key: string
  }> {
    const myArr: any = {};
    _.each(info.init.value, (value, key) => {
      if (!myArr[key]) {
        myArr[key] = {};
      }
      myArr[key].start = value;
    });
    _.each(info.finish.value, (value, key) => {
      if (!myArr[key]) {
        myArr[key] = {};
      }
      myArr[key].finish = value;
    });

    const newArr = [];
    _.each(myArr, (item, k) => {
      newArr.push({
        key: k,
        start: +item.start,
        finish: +item.finish,
        countOnStart: +Math.floor(+this.sum / +item.start),
        remainder: +(this.sum - item.start * Math.floor(+this.sum / +item.start)).toFixed(2),
        finSum: +this.getFinishSum0(item.finish, Math.floor(+this.sum / +item.start), (this.sum - item.start * Math.floor(+this.sum / +item.start)).toFixed(2)),
        increment: +this.getIncrement0(item.finish, Math.floor(+this.sum / +item.start), (this.sum - item.start * Math.floor(+this.sum / +item.start)).toFixed(2))

      });
    });

    return newArr;

  }

  trackByFn(index, item) {
    return item.key;
  }

  getFinishSum0(finish, countOnStart, remainder): any {
    return (+(+finish * +countOnStart).toFixed(2) + +remainder).toFixed(2);
  }

  getFinishSum(item): any {
    return (+(+item.finish * +item.countOnStart).toFixed(2) + +item.remainder).toFixed(2);
  }

  getIncrement(item): any {
    return (this.getFinishSum(item) - this.sum).toFixed(2);
  }


  getIncrement0(finish, countOnStart, remainder): any {
    return +(this.getFinishSum0(finish, countOnStart, remainder) - this.sum).toFixed(2);
  }


  getIncrementProcent(increment) {
    return (increment * 100 / this.sum).toFixed(2);
  }

  setSortType(type): void {
    this.type = type;
    this.reverse = !this.reverse;
  }
}

