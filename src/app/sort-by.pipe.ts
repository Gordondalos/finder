import { Pipe, PipeTransform } from '@angular/core';
import * as _ from 'lodash';

@Pipe({
  name: 'sortBy'
})
export class SortByPipe implements PipeTransform {

  transform(value: any, type: string, reverse: boolean): Array<{
    start: number,
    finish: number,
    countOnStart: number,
    remainder: number,
    finSum: number,
    increment: number,
    key: string
  }> {
    if (reverse) {
      return _.sortBy(value, [(item) => {
        return item[type];
      }]).reverse();
    } else {
      return _.sortBy(value, [(item) => {
        return item[type];
      }]);
    }


  }

}
