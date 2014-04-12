describe('constant', function() {
  var constant;

  beforeEach(angular.mock.module('evtsim'));
  beforeEach(angular.mock.inject(function(_constant_){
    constant = _constant_;
  }));

  it('should be able to get constant', function() {
    expect(constant.stycnt).toBe(20);
    expect(constant.evtcnt).toBe(4);
  });
  
});