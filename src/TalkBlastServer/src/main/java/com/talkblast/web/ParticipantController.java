package com.talkblast.web;

import org.springframework.roo.addon.web.mvc.controller.RooWebScaffold;
import com.talkblast.domain.Participant;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;

@RooWebScaffold(path = "participants", formBackingObject = Participant.class)
@RequestMapping("/participants")
@Controller
public class ParticipantController {
}
