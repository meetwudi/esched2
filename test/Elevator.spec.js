describe('Elevator', function() {
  var Elevator;

  beforeEach(angular.mock.module('evtsim'));
  beforeEach(angular.mock.inject(function(_Elevator_){
    Elevator = _Elevator_;
  }));

  it('should be able to add request from status 0 and start running', function() {
    var evt = new Elevator();
    runs(function() {
      evt.addRequest(4);
    });
    
    waitsFor(function() {
      return evt.cursty === 4;
    }, "elevator should be on 4th floor", 10000);

    runs(function() {
      expect(evt.cursty).toBe(4);
    });
  });
}); 