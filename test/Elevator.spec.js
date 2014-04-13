describe('Elevator', function() {
  var Elevator;

  beforeEach(angular.mock.module('evtsim'));
  beforeEach(angular.mock.inject(function(_Elevator_){
    Elevator = _Elevator_;
  }));
  beforeEach(function() {
    jasmine.DEFAULT_TIMEOUT_INTERVAL = 999999999;
  })

  // it('should be able to add request from status 0 and start running', function(done) {
  //   var evt = new Elevator(1);
  //   console.log('到5楼');
  //   evt.addRequest(5);
  //   setTimeout(function() {
  //     done();
  //   }, 6000);
  // });

  it('should be able to run properly', function(done) {
    var evt = new Elevator(2);
    console.log('到5楼，10秒后再到10楼');
    evt.addRequest(5);
    setTimeout(function() {
      evt.addRequest(10);
      setTimeout(function() {
        console.log(JSON.stringify(evt));
        done();
      }.bind(this), 10000);
    }.bind(this), 10000);
  });

  it('should be able to run properly 2', function(done) {
    var evt = new Elevator(2);
    console.log('到10楼，15秒后再到6楼和3楼');
    evt.addRequest(10);
    setTimeout(function() {
      evt.addRequest(3);
      evt.addRequest(6);
      setTimeout(function() {
        console.log(JSON.stringify(evt));
        done();
      }.bind(this), 15000);
    }.bind(this), 15000);
  });

  it('should be able to run properly 3', function(done) {
    var evt = new Elevator(2);
    console.log('到2 5 7楼，15秒后到5楼');
    evt.addRequest(2);
    evt.addRequest(5);
    evt.addRequest(3);
    evt.addRequest(7);
    setTimeout(function() {
      evt.addRequest(5);
      setTimeout(function() {
        console.log(JSON.stringify(evt));
        done();
      }.bind(this), 15000);
    }.bind(this), 15000);
  });
}); 