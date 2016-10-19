package com.crazypig.zkbrowser.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * 
 * @author CrazyPig
 * @since 2016-10-18
 *
 */
@Controller
public class IndexController {
	
	@RequestMapping({"/", "/index"})
	public ModelAndView index() {
		
		return new ModelAndView("index");
		
	}

}
