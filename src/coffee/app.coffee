# Elevator Simulator
# Author: John Wu (Tongji University)

angular.module("evtsim", [])

.constant('constant', 
  styids: [1..20]
  evtids: [0..4]
)



.directive("evtCtrl", ['constant', (constant) ->
  replace: true
  transclude: true
  scope:
    evtid: '@'  # 电梯的编号（0 ~ 4）
  template: '<section class="ctrl-evt"> 
              <div class="form-common"> 
                <button>开门</button> 
                <button>关门</button> 
                <button>警报</button> 
              </div> 
              <div class="form-num"> 
                <button ng-repeat="styid in styids" data-evtid="{{evtid}}" data-styid="{{styid}}" data-ctrltype="inner">{{styid}}</button> 
              </div> 
            </section>'
  link: (scope, el, attrs) -> 
    scope.styids = constant.styids
])


.directive("styCtrl", [ ->
  replace: true
  transclude: true
  scope:
    styid: '@'
  template:
    '<section class="ctrl-sty">
      <h5>{{styid}}</h5>
      <div class="form-arrow">
        <button data-styid="{{styid}}" data-ctrltype="outer" data-dir="up">↑</button>
        <button data-styid="{{styid}}" data-ctrltype="outer" data-dir="down">↓</button>
      </div>
    </section>'
  link: (scope, el, attrs) -> 
    scope.get
])