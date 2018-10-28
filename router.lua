local route = require('providers.route_service_provider')

local _M = {}

function _M:init()
    ngx.ctx.middleware_group = {}
    self:routes()
    ngx.log(ngx.WARN, 'not find method, uri in router.lua or didn`t response in action, current method:'.. ngx.var.request_method ..' current uri:'..ngx.var.request_uri)
end

function _M:routes()
    route:group({
        -- 'locale',
        -- 'throttle'
    }, function()
        route:get('/posts', 'post_controller', 'index')
        route:get('/posts/count', 'post_controller', 'count')
        route:get('/tags', 'post_controller', 'tags')
        route:get('/users/top', 'user_controller', 'top')
        route:get('/users/count', 'user_controller', 'count')
        route:get('/users/{id}', 'user_controller', 'show')
        route:get('/posts/{id}', 'post_controller', 'show')
        route:post('/login', 'auth_controller', 'login')
        route:post('/send/sms', 'notify/sms_notify_controller', 'guest_send_sms')
        route:get('/oauth/wechat/web', 'wechat_controller', 'webLogin')
        route:group({
            'verify_guest_sms_code'
        }, function()
            route:post('/register', 'auth_controller', 'register')
            route:patch('/forget-password', 'auth_controller', 'forget_password')
        end)
        route:group({
            'authenticate',
        }, function()
            route:post('/posts/{id}/comments', 'comment_controller', 'create')
            route:post('/posts/{id}/favor', 'post_controller', 'favor')
            route:post('/posts', 'post_controller', 'store')
            route:put('/posts/{id}', 'post_controller', 'update')
            route:post('/users/send/sms', 'notify/sms_notify_controller', 'user_send_sms')
            route:post('/logout', 'auth_controller', 'logout')
            route:patch('/reset-password', 'auth_controller', 'reset_password')
            route:group({
                'token_refresh'
            }, function()
                route:get('/userinfo', 'user_controller', 'userinfo')
                -- test upsteam usage (suppose /home api write by Java or PHP) use nginx reverse proxy
                route:get('/home')
            end)
        end)
    end)
end

return _M