package com.talkblast.web;

import java.util.List;

import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;

import com.talkblast.domain.CallHistory;
import com.talkblast.domain.Uzer;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RooWebScaffold(path = "uzers", formBackingObject = Uzer.class)
@RequestMapping("/uzers")
@Controller
public class UserController {
    
    @RequestMapping(value = "/{username}/history", method = RequestMethod.GET)
    public @ResponseBody List<CallHistory> getCallHistories(@PathVariable("username") String username) {
        List<CallHistory> result = CallHistory.findUserByUsername(username);
        
        return result;
    } 
}
