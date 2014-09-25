/*!
 * Chapeau 1.0.0
 *
 * Chapeau may be freely distributed under the MIT license.
 * For all details and documentation:
 * http://chapeaujs.org
 */

(function(){

var loader = (function() {
  var modules = {};
  var cache = {};

  var dummy = function() {return function() {};};
  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    definition(module.exports, dummy(), module);
    var exports = cache[name] = module.exports;
    return exports;
  };

  var loader = function(path) {
    if (cache.hasOwnProperty(path)) return cache[path];
    if (modules.hasOwnProperty(path)) return initModule(path, modules[path]);
    throw new Error('Cannot find module "' + path + '"');
  };

  loader.register = function(bundle, fn) {
    modules[bundle] = fn;
  };
  return loader;
})();

loader.register('chapeau/application', function(e, r, module) {
'use strict';
var Application, Chaplin, Collection, global, mediator, utils, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

if (typeof window !== "undefined" && window !== null) {
  window.global = global = window;
} else if (global == null) {
  global = {};
}

_ = loader('underscore');

Chaplin = loader('chaplin');

utils = loader('chapeau/lib/utils');

Collection = loader('chapeau/models/collection');

global.mediator = mediator = loader('chapeau/mediator');

module.exports = Application = (function(_super) {
  __extends(Application, _super);

  Application.prototype.settings = {
    controllerSuffix: '-controller',
    collectionsAutoSingleton: true,
    globalAutoload: true
  };

  Application.prototype.classList = {
    views: {},
    collections: {},
    models: {},
    helpers: {},
    templates: {},
    controllers: {},
    misc: {},
    bases: {}
  };

  Application.prototype.orderedRequireList = {
    views: [],
    collections: [],
    models: [],
    helpers: [],
    templates: [],
    controllers: [],
    misc: [],
    bases: []
  };

  function Application(options) {
    _.extend(this.settings, this.options, options);
    global.dummyCollection = new Collection;
    if (this.settings.globalAutoload) {
      this.autoload();
    }
    Application.__super__.constructor.call(this, this.settings);
  }

  Application.prototype.initMediator = function() {
    var Col, collectionPath, name, _ref;
    if (this.settings.collectionsAutoSingleton) {
      _ref = this.classList.collections;
      for (collectionPath in _ref) {
        Col = _ref[collectionPath];
        name = utils.pluralize(collectionPath.replace(/-collection$/, ''));
        mediator[name] = new Col;
      }
    }
    mediator.canUseLocalStorage = this._checkLocalStorage();
    return Application.__super__.initMediator.apply(this, arguments);
  };

  Application.prototype._checkLocalStorage = function() {
    var e, test;
    test = 'test';
    try {
      localStorage.setItem(test, test);
      localStorage.removeItem(test);
      return true;
    } catch (_error) {
      e = _error;
      return false;
    }
  };

  Application.prototype.autoload = function() {
    var baseOrder, baseSortr, r, sortr, topDir, _i, _len, _ref;
    global.application = this;
    _ref = (global.require || require).list();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      r = _ref[_i];
      topDir = r.split('/')[0];
      if (this.orderedRequireList[topDir]) {
        if (topDir === 'views' && !_.endsWith(r, '-view')) {
          this.orderedRequireList.templates.push(r);
        } else if (_(r).startsWith('helpers/base')) {
          this.orderedRequireList.bases.push(r);
        } else {
          this.orderedRequireList[topDir].push(r);
        }
      } else {
        this.orderedRequireList.misc.push(r);
      }
    }
    sortr = function(a, b) {
      var bi;
      if (-1 !== (bi = b.indexOf('abstract')) || -1 !== a.indexOf('abstract')) {
        return bi;
      }
      return b.split('/').length - a.split('/').length;
    };
    baseOrder = ['view', 'layout', 'controller', 'model', 'collection', 'collection_view'];
    baseSortr = function(a, b) {
      if (-1 === (a = baseOrder.indexOf(a.split('/').pop()))) {
        return 1;
      }
      if (-1 === (b = baseOrder.indexOf(b.split('/').pop()))) {
        return -1;
      }
      return a - b;
    };
    this.orderedRequireList.views.sort(sortr);
    this.orderedRequireList.controllers.sort(sortr);
    this.orderedRequireList.models.sort(sortr);
    this.orderedRequireList.collections.sort(sortr);
    this.orderedRequireList.bases.sort(baseSortr);
    this.preload('bases');
    this.preload('helpers');
    this.preload('models');
    this.preload('collections');
    this.preload('templates');
    this.preload('views');
    return this.preload('controllers');
  };

  Application.prototype.preload = function(type) {
    var d, dirs, name, r, _i, _len, _ref;
    _ref = this.orderedRequireList[type];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      r = _ref[_i];
      dirs = r.split('/');
      dirs.shift();
      if ((type === 'views' || type === 'templates' || type === 'controllers') && dirs[dirs.length - 2] === dirs[dirs.length - 1].replace('-view', '')) {
        dirs[dirs.length - 2] = '';
      }
      d = dirs.join('-');
      switch (type) {
        case 'views':
        case 'collections':
        case 'controllers':
          name = _.classify(d);
          break;
        case 'bases':
          name = _.classify(d.replace('base-', ''));
          break;
        default:
          name = _.classify("" + d + "-" + (type.slice(0, -1)));
      }
      global[name] = this.classList[type][d] = require(r);
    }
  };

  Application.prototype.start = function() {
    if ('function' === typeof this.beforeStart) {
      return this.beforeStart((function(_this) {
        return function() {
          return Application.__super__.start.apply(_this, arguments);
        };
      })(this));
    }
    return Application.__super__.start.apply(this, arguments);
  };

  return Application;

})(Chaplin.Application);

});;loader.register('chapeau/mediator', function(e, r, module) {
'use strict';
var Chaplin, mediator;

Chaplin = loader('chaplin');

mediator = Chaplin.mediator;

mediator.onLy = function(eventName) {
  this.offLy(eventName);
  return this.on.apply(this, arguments);
};

mediator.offLy = function(eventName) {
  return delete mediator._events[eventName];
};

module.exports = mediator;

});;loader.register('chapeau/dispatcher', function(e, r, module) {


});;loader.register('chapeau/composer', function(e, r, module) {


});;loader.register('chapeau/controllers/controller', function(e, r, module) {
'use strict';
var Chaplin, Controller, global, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

if (typeof window !== "undefined" && window !== null) {
  window.global = global = window;
} else if (global == null) {
  global = {};
}

_ = loader('underscore');

Chaplin = loader('chaplin');

module.exports = Controller = (function(_super) {
  __extends(Controller, _super);

  function Controller() {
    return Controller.__super__.constructor.apply(this, arguments);
  }

  Controller.prototype.beforeAction = function(params, route) {
    if (global.ENV !== 'production') {
      log("[c='font-size: 1.2em;color:#d33682;font-weight:bold']▚ " + route.name + "[c]\t\t", route);
    }
    return Controller.__super__.beforeAction.apply(this, arguments);
  };

  return Controller;

})(Chaplin.Controller);

});;loader.register('chapeau/models/collection', function(e, r, module) {
'use strict';
var Chaplin, Collection, Model, global, utils, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

if (typeof window !== "undefined" && window !== null) {
  window.global = global = window;
} else if (global == null) {
  global = {};
}

_ = loader('underscore');

Chaplin = loader('chaplin');

Model = loader('chapeau/models/model');

utils = loader('chapeau/lib/utils');

module.exports = Collection = (function(_super) {
  __extends(Collection, _super);

  _(Collection.prototype).extend(Chaplin.SyncMachine);

  Collection.prototype.model = null;

  Collection.prototype.subset = {};

  Collection.prototype.meta = null;

  function Collection() {
    this._className = utils.className(this).replace('Collection', '');
    if (!this.model) {
      this.model = global[this._className + 'Model'] || Model;
    }
    this.subset = {};
    this.storeName = 'App::' + this._className;
    Collection.__super__.constructor.apply(this, arguments);
  }

  Collection.prototype.subfilter = function(f) {
    return this.subcollection({
      filter: f
    });
  };

  Collection.prototype.first = function(n) {
    var models;
    models = Collection.__super__.first.apply(this, arguments);
    if (!n) {
      return models;
    }
    return this.subfilter(function(model) {
      return -1 !== models.indexOf(model);
    });
  };

  Collection.prototype.last = function(n) {
    var models;
    models = Collection.__super__.last.apply(this, arguments);
    if (!n) {
      return models;
    }
    return this.subfilter(function(model) {
      return -1 !== models.indexOf(model);
    });
  };

  Collection.prototype.where = function(attrs, first) {
    var cacheKey, f;
    cacheKey = 'where:' + JSON.stringify(attrs);
    if (_.isEmpty(attrs)) {
      return (first ? void 0 : []);
    }
    f = function(model) {
      var key;
      for (key in attrs) {
        if (attrs[key] !== model.get(key)) {
          return false;
        }
      }
      return true;
    };
    if (first) {
      return this.find(f);
    } else {
      return this.subset[cacheKey] || (this.subset[cacheKey] = this.subfilter(f));
    }
  };

  return Collection;

})(Chaplin.Collection);

});;loader.register('chapeau/models/model', function(e, r, module) {
'use strict';
var Chaplin, Model, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ = loader('underscore');

Chaplin = loader('chaplin');

module.exports = Model = (function(_super) {
  __extends(Model, _super);

  function Model() {
    return Model.__super__.constructor.apply(this, arguments);
  }

  _(Model.prototype).extend(Chaplin.SyncMachine);

  Model.prototype.get = function(k) {
    var m;
    if (!this[m = 'get' + k.charAt(0).toUpperCase() + k.slice(1)]) {
      return Model.__super__.get.apply(this, arguments);
    }
    return this[m]();
  };

  Model.prototype.set = function(k, v) {
    var m;
    if (!('string' === typeof k && this[m = 'set' + k.charAt(0).toUpperCase() + k.slice(1)])) {
      return Model.__super__.set.apply(this, arguments);
    }
    return this[m](v);
  };

  return Model;

})(Chaplin.Model);

});;loader.register('chapeau/views/layout', function(e, r, module) {
'use strict';
var Chaplin, Layout, View, global, utils, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

if (typeof window !== "undefined" && window !== null) {
  window.global = global = window;
} else if (global == null) {
  global = {};
}

_ = loader('underscore');

Chaplin = loader('chaplin');

View = loader('chapeau/views/view');

utils = loader('chapeau/lib/utils');

module.exports = Layout = (function(_super) {
  __extends(Layout, _super);

  function Layout(options) {
    this._className = utils.className(this);
    Layout.__super__.constructor.apply(this, arguments);
  }

  Layout.prototype.isExternalLink = function(link) {
    var resp, _ref, _ref1;
    resp = link.target === '_blank' || link.rel === 'external' || ((_ref = link.protocol) !== 'https:' && _ref !== 'http:' && _ref !== ':' && _ref !== 'file:' && _ref !== location.protocol) || ((_ref1 = link.hostname) !== location.hostname && _ref1 !== '');
    return resp;
  };

  return Layout;

})(Chaplin.Layout);

});;loader.register('chapeau/views/view', function(e, r, module) {
'use strict';
var Chaplin, Model, View, global, utils, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

if (typeof window !== "undefined" && window !== null) {
  window.global = global = window;
} else if (global == null) {
  global = {};
}

_ = loader('underscore');

Chaplin = loader('chaplin');

Model = loader('chapeau/models/model');

utils = loader('chapeau/lib/utils');

module.exports = View = (function(_super) {
  __extends(View, _super);

  View.prototype.autoRender = true;

  View.prototype.getTemplateFunction = function() {
    if (this.template) {
      return this.template;
    }
    this._className = this._className || utils.className(this);
    return global[this._className.replace(/View$/, 'Template')];
  };

  View.prototype.initAttributes = function() {
    var d;
    this._className = this._className || utils.className(this);
    d = _.dasherize(this._className.charAt(0).toLowerCase() + this._className.slice(1));
    return this.className = !this.className ? d : this.className + ' ' + d;
  };

  function View(options) {
    this.initAttributes();
    if (!this.model) {
      this.model = new Model;
    }
    View.__super__.constructor.apply(this, arguments);
  }

  View.prototype.dispose = function() {
    if (!(global.ENV === 'production' || this.noDebug)) {
      log("[c='font-weight:bold;margin-left:20px;color:#268bd2;']❖ " + this._className + "::[c][c='font-weight:bold;color:#b58900']dispose[c]\t\t", this);
    }
    return (typeof this.beforeDispose === "function" ? this.beforeDispose((function(_this) {
      return function(canDispose) {
        if (canDispose !== false) {
          return View.__super__.dispose.apply(_this, arguments);
        }
      };
    })(this)) : void 0) || View.__super__.dispose.apply(this, arguments);
  };

  View.prototype.delegateEvents = function(events, keepOld) {
    View.__super__.delegateEvents.apply(this, arguments);
    return this.delegateHammerEvents();
  };

  View.prototype.doRender = function() {
    var html, templateFunc;
    templateFunc = this.getTemplateFunction();
    if (typeof templateFunc !== 'function') {
      return this;
    }
    html = templateFunc(this.getTemplateData());
    if (global.toStaticHTML != null) {
      html = toStaticHTML(html);
    }
    this.$el.html(html);
    this.enhance();
    return typeof this.afterRender === "function" ? this.afterRender() : void 0;
  };

  View.prototype.render = function() {
    if (this.disposed) {
      return false;
    }
    if (global.ENV !== 'production') {
      if (!this.noDebug) {
        log("[c='font-weight:bold;margin-left:20px;color:#268bd2;']❖ " + this._className + "::[c][c='font-weight:bold;color:#b58900']render[c]\t\t", this);
      }
    }
    return (typeof this.beforeRender === "function" ? this.beforeRender((function(_this) {
      return function(canRender) {
        if (canRender !== false) {
          return _this.doRender();
        }
      };
    })(this)) : void 0) || this.doRender();
  };

  View.prototype.enhance = function() {
    return this.$('a[data-route]').each(function() {
      var k, routeName, routeParams, uri, v, _ref;
      this.$ = $(this);
      routeParams = this.$.is('[data-route-reset]') ? {} : _.extend({}, mediator.lastRouteParams);
      routeName = null;
      _ref = this.$.data();
      for (k in _ref) {
        v = _ref[k];
        if (k === 'route') {
          routeName = v;
        } else if (k !== 'routeReset' && 0 === k.indexOf('route')) {
          routeParams[(k = k.substr(5)).charAt(0).toLowerCase() + k.slice(1)] = v;
        }
      }
      uri = '#';
      try {
        uri = Chaplin.utils.reverse(routeName, routeParams);
      } catch (_error) {}
      this.$.attr('href', uri);
      this.$.off('click');
      return this.$.on('click', function(e) {
        var el, href, isAnchor;
        if (Chaplin.utils.modifierKeyPressed(event)) {
          return;
        }
        el = event.currentTarget;
        isAnchor = el.nodeName === 'A';
        href = el.getAttribute('href') || el.getAttribute('data-href') || null;
        Chaplin.utils.redirectTo({
          url: href
        });
        event.preventDefault();
        return false;
      });
    });
  };

  return View;

})(Chaplin.View);

});;loader.register('chapeau/views/collection_view', function(e, r, module) {
'use strict';
var Chaplin, CollectionView, View, global, utils, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

if (typeof window !== "undefined" && window !== null) {
  window.global = global = window;
} else if (global == null) {
  global = {};
}

_ = loader('underscore');

Chaplin = loader('chaplin');

View = loader('chapeau/views/view');

utils = loader('chapeau/lib/utils');

module.exports = CollectionView = (function(_super) {
  __extends(CollectionView, _super);

  CollectionView.prototype.getTemplateFunction = View.prototype.getTemplateFunction;

  CollectionView.prototype.initAttributes = View.prototype.initAttributes;

  CollectionView.prototype.useCssAnimation = true;

  CollectionView.prototype.enhance = View.prototype.enhance;

  CollectionView.prototype.dispose = View.prototype.dispose;

  CollectionView.prototype.render = View.prototype.render;

  function CollectionView(options) {
    this._className = utils.className(this);
    if (!this.itemView) {
      this.itemView = global[this._className.replace('View', 'ItemView')];
    }
    if (!this.listSelector && global[this._className.replace(/View$/, 'Template')]) {
      this.listSelector = '.list';
    }
    this.initAttributes();
    if (!this.model) {
      this.model = new Model;
    }
    CollectionView.__super__.constructor.apply(this, arguments);
  }

  CollectionView.prototype.getTemplateData = function() {
    var templateData;
    templateData = CollectionView.__super__.getTemplateData.apply(this, arguments);
    if (this.model) {
      templateData = _.extend(Chaplin.utils.serialize(this.model, templateData));
      if (typeof this.model.isSynced === 'function' && !this.model.isSynced()) {
        templateData.synced = false;
      }
    }
    return templateData;
  };

  CollectionView.prototype.doRender = function() {
    var html, listSelector, templateFunc;
    templateFunc = this.getTemplateFunction();
    if (typeof templateFunc !== 'function') {
      return this;
    }
    html = templateFunc(this.getTemplateData());
    if (global.toStaticHTML != null) {
      html = toStaticHTML(html);
    }
    this.$el.html(html);
    listSelector = _.result(this, 'listSelector');
    this.$list = listSelector ? this.$(listSelector) : this.$el;
    this.initFallback();
    this.initLoadingIndicator();
    if (this.renderItems) {
      this.renderAllItems();
    }
    this.enhance();
    return typeof this.afterRender === "function" ? this.afterRender() : void 0;
  };

  CollectionView.prototype.resetCollection = function(newCollection) {
    this.stopListening(this.collection);
    this.collection = newCollection;
    this.listenTo(this.collection, 'add', this.itemAdded);
    this.listenTo(this.collection, 'remove', this.itemRemoved);
    this.listenTo(this.collection, 'reset sort', this.itemsReset);
    return this.itemsReset();
  };

  return CollectionView;

})(Chaplin.CollectionView);

});;loader.register('chapeau/lib/utils', function(e, r, module) {
'use strict';
var utils, _;

_ = loader('underscore');

utils = {
  functionName: function(f) {
    var ret;
    ret = f.toString().substr(9);
    return ret.substr(0, ret.indexOf('('));
  },
  className: function(c) {
    var ret;
    ret = c.constructor.toString().substr(9);
    return ret.substr(0, ret.indexOf('('));
  },
  _pluralRules: [['m[ae]n$', 'men'], ['(eau)x?$', '$1x'], ['(child)(?:ren)?$', '$1ren'], ['(pe)(?:rson|ople)$', '$1ople'], ['^(m|l)(?:ice|ouse)$', '$1ice'], ['(matr|cod|mur|sil|vert|ind)(?:ix|ex)$', '$1ices'], ['(x|ch|ss|sh|zz)$', '$1es'], ['([^ch][ieo][ln])ey$', '$1ies'], ['([^aeiouy]|qu)y$', '$1ies'], ['(?:([^f])fe|(ar|l|[eo][ao])f)$', '$1$2ves'], ['sis$', 'ses'], ['^(apheli|hyperbat|periheli|asyndet|noumen)(?:a|on)$', '$1a'], ['^(phenomen|criteri|organ|prolegomen|\w+hedr)(?:a|on)$', '$1a'], ['^(agend|addend|millenni|ov|dat|extrem|bacteri|desiderat)(?:a|um)$', '$1a'], ['^(strat|candelabr|errat|symposi|curricul|automat|quor)(?:a|um)$', '$1a'], ['(her|at|gr)o$', '$1oes'], ['^(alumn|alg|vertebr)(?:a|ae)$', '$1ae'], ['(alumn|syllab|octop|vir|radi|nucle|fung|cact)(?:us|i)$', '$1i'], ['(stimul|termin|bacill|foc|uter|loc)(?:us|i)$', '$1i'], ['([^l]ias|[aeiou]las|[emjzr]as|[iu]am)$', '$1'], ['([^l]ias|[aeiou]las|[emjzr]as|[iu]am)$', '$1'], ['(e[mn]u)s?$', '$1s'], ['(alias|[^aou]us|tlas|gas|ris)$', '$1es'], ['^(ax|test)is$', '$1es'], ['([^aeiou]ese)$', '$1'], ['s?$', 's']],
  pluralize: function(s) {
    var r, v, _i, _len, _ref;
    _ref = this._pluralRules;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      v = _ref[_i];
      if (!(r = new RegExp(v[0])).test(s)) {
        continue;
      }
      return s.replace(r, v[1]);
    }
    return s;
  }
};

if (typeof Object.seal === "function") {
  Object.seal(utils);
}

module.exports = utils;

});;loader.register('chapeau', function(e, r, module) {
module.exports = {
  Application: loader('chapeau/application'),
  mediator: loader('chapeau/mediator'),
  Controller: loader('chapeau/controllers/controller'),
  Collection: loader('chapeau/models/collection'),
  Model: loader('chapeau/models/model'),
  Layout: loader('chapeau/views/layout'),
  View: loader('chapeau/views/view'),
  CollectionView: loader('chapeau/views/collection_view'),
  utils: loader('chapeau/lib/utils')
};

});
var regDeps = function(Backbone, _, Chaplin) {
  loader.register('backbone', function(exports, require, module) {
    module.exports = Backbone;
  });
  loader.register('underscore', function(exports, require, module) {
    module.exports = _;
  });
  loader.register('chaplin', function(exports, require, module) {
    module.exports = Chaplin;
  });
};

if (typeof define === 'function' && define.amd) {
  define(['backbone', 'underscore', 'chapeau'], function(Backbone, _) {
    regDeps(Backbone, _, Chaplin);
    return loader('chapeau');
  });
} else if (typeof module === 'object' && module && module.exports) {
  regDeps(require('backbone'), require('underscore'), require(window.Chaplin));
  module.exports = loader('chapeau');
} else if (typeof require === 'function') {
  regDeps(window.Backbone, window._ || window.Backbone.utils, window.Chaplin);
  window.Chapeau = loader('chapeau');
} else {
  throw new Error('Chapeau requires Common.js or AMD modules');
}

})();