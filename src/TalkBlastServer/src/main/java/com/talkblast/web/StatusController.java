package com.talkblast.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/status")
@Controller
public class StatusController {

	@RequestMapping(method = RequestMethod.GET)
	public @ResponseBody String getStatus() {
		return Boolean.TRUE.toString();
	}
}
