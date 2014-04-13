###
  Elevator Simulator
  Author: John Wu (Tongji University)
###

app = angular.module("evtsim", [])

app.constant('constant', 
  # 电梯和楼层数据
  stycnt: 20      
  styids: [1..20]
  evtcnt: 4
  evtids: [0..4]
  # 单位时间
  timeunit: 1000 
)

app.factory('RequestQueue', ['constant', (constant) ->
  class RequestQueue
    # @data: 若@data[i]为true则代表是否要到该楼层
    constructor: () ->
      @_data = [false]
      @_data.push(false) for _ in [1..constant.stycnt]

    isEmpty: ->
      for item in @_data
        if item
          return false
      return true

    addRequest: (styid, cursty, status) ->
      console.log("添加中#{styid} #{cursty} #{status}");
      # 成功返回true，否则返回false
      if (status is 1 and cursty > styid) or (status is -1 and cursty < styid) or (not(1 <= styid  <= constant.stycnt)) or (not(1 <= cursty <= constant.stycnt))
         return false
      @_data[styid] = true
      true

    resolveRequest: (styid) ->
      @_data[styid] = false

    getNearestRequest: (cursty, status) ->
      return @_getNearestRequestFromBottomToTop(cursty) if status is 1
      return @_getNearestRequestFromTopToButtom(cursty) if status is -1
      @_getNearestRequestFromBottomToTop(cursty) ? @_getNearestRequestFromTopToButtom(cursty)

    _getNearestRequestFromBottomToTop: (cursty) ->
      for sty in [cursty..constant.stycnt] 
        if @_data[sty]
          return sty
      -1 # 上升方向没有要去的地方了

    _getNearestRequestFromTopToButtom: (cursty) ->
      for sty in [cursty..1]
        if @_data[sty]
          return sty
      -1 # 下降方向没有要去的地方了

])

app.factory('Elevator', ['RequestQueue', 'constant', '$rootScope', (RequestQueue, constant, $rootScope) ->
  class Elevator 
    # @status: 0: 暂停, 1: 上行, -1: 下行
    constructor: (@id) ->
      @cursty = 1    # 一开始全部电梯在一楼
      @status = 0
      @requestQueue = new RequestQueue
      @_fakeThreadWorking = false
      @_fakeThreadFn = @_step.bind(@)

    addRequest: (styid, callback) ->
      result = @requestQueue.addRequest(styid, @cursty, @status)
      console.log("【电梯#{@id}】：addRequest: 添加请求到#{styid}楼, 目前电梯状态#{@status}")
      if result
        @onStatusMayChange()
        return true
      else
        return false

    onStatusMayChange: ->
      if @requestQueue.isEmpty() and @status isnt 0
        @status = 0
        console.log("【电梯#{@id}】：状态改到0")
      else if (@requestQueue.getNearestRequest(@cursty, @status) >= @cursty) and (@status isnt 1)
        @status = 1
        console.log("【电梯#{@id}】：状态改到1")
      else if (@requestQueue.getNearestRequest(@cursty, @status) <= @cursty) and (@status isnt -1)
        @status = -1 
        console.log("【电梯#{@id}】：状态改到-1")
      $rootScope.$apply()

      if (not @_fakeThreadWorking) and (not @requestQueue.isEmpty())
        setTimeout(@_fakeThreadFn, constant.timeunit)
        @_fakeThreadWorking = true

    _step: ->
      nearestRequest = @requestQueue.getNearestRequest(@cursty, @status)
      if nearestRequest is @cursty
        @requestQueue.resolveRequest(@cursty)
        console.log("【电梯#{@id}】：到达一次目的地，这里是#{@cursty}")
        @_fakeThreadWorking = false 
        @onStatusMayChange()
      else 
        if nearestRequest > @cursty
          @_moveUp()
        else
          @_moveDown()
        setTimeout(@_fakeThreadFn, constant.timeunit)

    _moveUp: -> 
      @cursty++
      $rootScope.$apply()
      console.log("【电梯#{@id}】：到#{@cursty}")

    _moveDown: -> 
      @cursty--
      $rootScope.$apply()
      console.log("【电梯#{@id}】到#{@cursty}")
])

app.factory('elevators', ['Elevator', 'constant', (Elevator, constant) ->
  evts = []
  for evtid in [0..constant.evtcnt]
    evts.push(new Elevator(evtid))
  evts
])

###
  RequestDispatcher 
  负责分发外部请求，在这里做无差异分发（即遇到可分发的电梯便分发）
###
app.service('RequestDispatcher', ['elevators', 'constant', (elevators, constant) -> 
  @dispatch = (sty, dir) ->
    for elevator in elevators
      if (Math.abs(dir - elevators.status) is 2)
        continue # 方向相反不考虑
      if elevator.addRequest(sty)
        return
    # 设定每个timeunit的一半为轮询周期
    setTimeout(constant.timeunit / 2, @dispatch)
])

app.directive("evtCtrl", ['constant', (constant) ->
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
                <button ng-repeat="styid in $parent.constant.styids" data-evtid="{{evtid}}" data-styid="{{styid}}" btn-inner>{{styid}}</button> 
              </div> 
            </section>'
])

app.directive("styCtrl", [ ->
  replace: true
  transclude: true
  scope:
    styid: '@'
  template:
    '<section class="ctrl-sty">
      <h5>{{styid}}</h5>
      <div class="form-arrow">
        <button data-styid="{{styid}}" data-dir="1" btn-outer>↑</button>
        <button data-styid="{{styid}}" data-dir="-1" btn-outer>↓</button>
      </div>
    </section>'
])

###
  btnInner
  触发内部请求的按钮
###
app.directive('btnInner', ['elevators', (elevators) ->
  link: (scope, el, attrs) -> 
    el.bind('click', (event) ->
      styid = el[0].dataset.styid
      evtid = el[0].dataset.evtid
      # 直接注册
      if not elevators[evtid].addRequest(styid)
        alert('注册任务失败！')
    )
])

###
  btnOuter
  触发外部请求的按钮
###
app.directive('btnOuter', ['RequestDispatcher', (RequestDispatcher) ->
  link: (scope, el, attrs) -> 
    el.bind('click', (event) ->
      styid = el[0].dataset.styid
      dir = el[0].dataset.dir
      # 委托RequestDispatcher分发请求
      RequestDispatcher.dispatch(styid, dir)
    )
])

app.run(['$rootScope', 'constant', 'elevators', ($rootScope, constant, elevators) ->
  $rootScope.constant = constant;
  $rootScope.elevators = elevators;
])