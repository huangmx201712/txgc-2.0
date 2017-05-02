package com.yp.sys.common;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.InitBinder;

import com.yp.sys.convertor.DateEditor;
import com.yp.sys.util.RequestUtil;


/**   
 * 文件名称：基础controller 
 * 内容摘要： 统一处理controller中的异常，绑定springMvc类型转换器
 * 创建人： huangfei
 * 创建日期： 2015年5月28日
 * 版本号： v1.0.0
 * 公  司：重庆重邮汇侧有限公司
 * 版权所有： (C)2001-2015     
 * 修改记录1 
 * 修改日期：
 * 版本号：
 * 修改人：
 * 修改内容：  
 **/ 
@Controller
public class BaseController {

	private static final Logger logger = Logger.getLogger(BaseController.class);
	
	/** 
	 * 统一异常处理
	 * @param e
	 * @param request:HttpServletRequest
	 * @return String
	 */
	@ExceptionHandler(Throwable.class)
    public String exception(Throwable e, HttpServletRequest request) {
		logger.error(this.getClass().getCanonicalName()+" some error happened",e);
		e.printStackTrace();
		boolean isAjax = RequestUtil.isAjaxRequest(request);
		if(isAjax){
			throw new RuntimeException();
		}else{
	        return "error/500";			
		}
    }
	/**
	 * 绑定springMvc类型转换器 
	 * @param binder void
	 */
	@InitBinder
	public void initBinder(WebDataBinder binder){
		//日期转换器
		binder.registerCustomEditor(Date.class, new DateEditor());
	} 

}
