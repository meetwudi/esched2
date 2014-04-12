describe('RequestQueue', function() {
  var RequestQueue;

  beforeEach(angular.mock.module('evtsim'));
  beforeEach(angular.mock.inject(function(_RequestQueue_){
    RequestQueue = _RequestQueue_;
  }));

  it('should be able to add request', function() {
    var rq = new RequestQueue();
    var result = rq.addRequest(2, 1, 0);
    expect(result).toBe(true);
    // hack checking
    var i;
    for (i = 1; i <= 20; i ++) {
      if (i === 2) {
        expect(rq._data[i]).toBe(true);
      }
      else {
        expect(rq._data[i]).toBe(false);
      }
    }
  });

  it('should be able to add request 2', function() {
    var rq = new RequestQueue();
    rq.addRequest(2, 1, 0);
    rq.addRequest(4, 1, 0);
    // hack checking
    var i;
    for (i = 1; i <= 20; i ++) {
      if (i === 2 || i === 4) {
        expect(rq._data[i]).toBe(true);
      }
      else {
        expect(rq._data[i]).toBe(false);
      }
    }
  });

  it('should not be able to add request in different direction', function() {
    var rq = new RequestQueue();
    rq.addRequest(3, 2, 0)
    var result = rq.addRequest(1, 2, 1);
    expect(result).toBe(false);
  });

  it('should be able to check if it is empty', function() {
    var rq = new RequestQueue();
    expect(rq.isEmpty()).toBe(true);
    rq.addRequest(2, 1, 0);
    expect(rq.isEmpty()).toBe(false);
  });

  it('should be able to resolve request', function() {
    var rq = new RequestQueue();
    expect(rq.isEmpty()).toBe(true);
    rq.addRequest(2, 1, 0);
    expect(rq.isEmpty()).toBe(false);
    rq.resolveRequest(2);
    expect(rq.isEmpty()).toBe(true);
  });

  it('should be get the correct nearest request', function() {
    var rq = new RequestQueue();
    expect(rq.getNearestRequest(1, 0)).toBe(-1);
    rq._data[2] = true;
    rq._data[10] = true;
    expect(rq.getNearestRequest(1, 1)).toBe(2);
    expect(rq.getNearestRequest(6, 1)).toBe(10);
    rq._data[12] = true;
    expect(rq.getNearestRequest(6, 1)).toBe(10);
  });

  it('should be get the correct nearest request 2', function() {
    var rq = new RequestQueue();
    expect(rq.getNearestRequest(1, 0)).toBe(-1);
    rq._data[2] = true;
    rq._data[10] = true;
    expect(rq.getNearestRequest(12, -1)).toBe(10);
    expect(rq.getNearestRequest(12, 1)).toBe(-1);
  });

  it('should be get the correct nearest request 3', function() {
    var rq = new RequestQueue();
    expect(rq.getNearestRequest(1, 0)).toBe(-1);
    rq._data[2] = true;
    rq._data[10] = true;
    expect(rq.getNearestRequest(6, 0)).toBe(10);
    expect(rq.getNearestRequest(6, 1)).toBe(10);
    expect(rq.getNearestRequest(6, -1)).toBe(2);
  });

  it('should be get the correct nearest request 4', function() {
    var rq = new RequestQueue();
    expect(rq.getNearestRequest(1, 0)).toBe(-1);
    rq._data[2] = true;
    expect(rq.getNearestRequest(2, 1)).toBe(2);
  });

});