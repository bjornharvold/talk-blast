package com.talkblast.web;

import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import com.talkblast.domain.CallHistory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;

@RooWebScaffold(path = "callhistorys", formBackingObject = CallHistory.class)
@RequestMapping("/callhistorys")
@Controller
public class CallHistoryController {
	
}
