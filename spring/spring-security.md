# spring security

作用: 认证, 授权, 安全防护(防止csrf跨站伪攻击等)

## 使用

## 理解

### 配置
WebSecurityConfiguration
WebSecurity

### authentication - 认证
`FilterChinaProxy` 内部内有一个静态内部类 `VirtualFilterChain` 过滤请求
这里只要主要是`doFilter`方法 

用到一个责任链模式, 就是一个请求过来, 一些操作,可以方便的增加或删除校验

主要的操作,都在`VirtualFilterChain` 下的  `doFilter` 里面执行

这里 我认为比较重要的代码，所有有些地方可能看起来不是那么顺畅
```java
public class FilterChainProxy extends GenericFilterBean {

	private List<SecurityFilterChain> filterChains;

	public FilterChainProxy(List<SecurityFilterChain> filterChains) {
		this.filterChains = filterChains;
	}

	public void doFilter(ServletRequest request, ServletResponse response
        ,FilterChain chain) {
		doFilterInternal(request, response, chain);
		SecurityContextHolder.clearContext();
	}

	private void doFilterInternal(ServletRequest request, ServletResponse response
            ,FilterChain chain) {

		FirewalledRequest fwRequest = firewall
				.getFirewalledRequest((HttpServletRequest) request);
		HttpServletResponse fwResponse = firewall
				.getFirewalledResponse((HttpServletResponse) response);

		List<Filter> filters = getFilters(fwRequest);

		VirtualFilterChain vfc = new VirtualFilterChain(fwRequest, chain, filters);
		vfc.doFilter(fwRequest, fwResponse);
	}

	private static class VirtualFilterChain implements FilterChain {
		private final FilterChain originalChain;
		private final List<Filter> additionalFilters;
		private final int size;
		private int currentPosition = 0;

		private VirtualFilterChain(FirewalledRequest firewalledRequest,
				FilterChain chain, List<Filter> additionalFilters) {
			this.originalChain = chain;
			this.additionalFilters = additionalFilters;
			this.size = additionalFilters.size();
		}

		@Override
		public void doFilter(ServletRequest request, ServletResponse response)
				throws IOException, ServletException {
			if (currentPosition == size) {
				originalChain.doFilter(request, response);
			}
			else {
				currentPosition++;
				Filter nextFilter = additionalFilters.get(currentPosition - 1);
				nextFilter.doFilter(request, response, this);
			}
		}
	}

}

```

这里以 UsernamerPassword 认证方式为列，安装顺序进过的 `Filter`

`WebAsyncManagerIntegrationFilter`: 给 `WebAsyncManager` 一个字段赋值

`SecurityContextPersistenceFilter`: 设置一些需要在安全认证中传递的数据, 默认是使用ThreadLocal
    `SecurityContextHolder` 类中的 strategy 字段 , 可以找到 `ThreadLocalSecurityContextHolderStrategy`

`HeaderWriterFilter`: 转换 request 和 response 类型为 HeaderWriterRequest, HeaderWriterResponse,

`LogoutFilter`: 是否是要退出的url(为什么可以知道哪个uri是退出的？肯定是配置啦)

`UsernamePasswordAuthenticationFilter`: 的dofilter在他的父类 `AbstractAuthenticationProcessingFilter`里面,
    根据请求的用户名密码封装成一个 `UsernamePasswordAuthenticationToken` 对象
    然后 通过接口 `AuthenticationManager` 的实现类 `ProviderManager`中的 `authenticate` 方法进行校验  
    就是在这里会通过 `DaoAuthenticationProvider` 中的`retrieveUser` 方法去调用 自己写的 实现`UserDetailsService` 中的`loadUserByUsername` 调用方法
    


### authorization - 授权

在用户认证完成之后, 会对校验是否该用户有访问该接口的权限，通过角色来控制

这里说明一点，security 模式是用session 来保存用户信息的,但是如果要用别的,比如jwt 来保存, 我们一样也需要

## 源码

#### 责任链模式

#### 策略模式

#### 单例模式


## spring boot security 默认配置

## 自定义spring security 用户认证逻辑

spring-security 里面封装了接口逻辑, 调用者只要实现了接口,就可以自定义逻辑了

#### 用户信息获取逻辑 UserDetailsService
 
#### 用户校验逻辑 UserDetails

#### 加密解密逻辑 PasswordEncoder

#### 自定义登录页面(配置)

#### 登录成功处理

#### 登录失败处理

#### 过滤器链
WebAsyncManagerIntegrationFilter@1d99c57d
SecurityContextPersistenceFilter@4670e2c6
HeaderWriterFilter@4ecb6b07
LogoutFilter@48fe96fe
UsernamePasswordAuthenticationFilter@12c6f30a
DefaultLoginPageGeneratingFilter@3beb7796
DefaultLogoutPageGeneratingFilter@610639d6
RequestCacheAwareFilter@3f1875ec
SecurityContextHolderAwareRequestFilter@70f3dc33
AnonymousAuthenticationFilter@1e7e5364
SessionManagementFilter@389da349
ExceptionTranslationFilter@477fb9ad 
FilterSecurityInterceptor@1d74b37

## 授权

## csrf 跨站伪造防护

## 附录

### 问题

Q1: 前后端分离 OPTIONS 

	reason 1: spring security 拦截了

	reason 2: 请求目的地址无访问权限

	reason 3: 请求方法错误 get 

02: json 登录


### idea 快捷键

Ctrl + H 看到该类的父子类




