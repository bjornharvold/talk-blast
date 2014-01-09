package com.talkblast.web;

import com.talkblast.domain.Participant;
import java.lang.Long;
import java.lang.String;
import javax.validation.Valid;
import org.springframework.core.convert.converter.Converter;
import org.springframework.core.convert.support.GenericConversionService;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

privileged aspect ParticipantController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String ParticipantController.create(@Valid Participant participant, BindingResult result, ModelMap modelMap) {
        if (result.hasErrors()) {
            modelMap.addAttribute("participant", participant);
            return "participants/create";
        }
        participant.persist();
        return "redirect:/participants/" + participant.getId();
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String ParticipantController.createForm(ModelMap modelMap) {
        modelMap.addAttribute("participant", new Participant());
        return "participants/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String ParticipantController.show(@PathVariable("id") Long id, ModelMap modelMap) {
        modelMap.addAttribute("participant", Participant.findParticipant(id));
        return "participants/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String ParticipantController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, ModelMap modelMap) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            modelMap.addAttribute("participants", Participant.findParticipantEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Participant.countParticipants() / sizeNo;
            modelMap.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            modelMap.addAttribute("participants", Participant.findAllParticipants());
        }
        return "participants/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String ParticipantController.update(@Valid Participant participant, BindingResult result, ModelMap modelMap) {
        if (result.hasErrors()) {
            modelMap.addAttribute("participant", participant);
            return "participants/update";
        }
        participant.merge();
        return "redirect:/participants/" + participant.getId();
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String ParticipantController.updateForm(@PathVariable("id") Long id, ModelMap modelMap) {
        modelMap.addAttribute("participant", Participant.findParticipant(id));
        return "participants/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String ParticipantController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size) {
        Participant.findParticipant(id).remove();
        return "redirect:/participants?page=" + ((page == null) ? "1" : page.toString()) + "&size=" + ((size == null) ? "10" : size.toString());
    }
    
    Converter<Participant, String> ParticipantController.getParticipantConverter() {
        return new Converter<Participant, String>() {
            public String convert(Participant participant) {
                return new StringBuilder().append(participant.getName()).append(" ").append(participant.getPhone()).toString();
            }
        };
    }
    
    @InitBinder
    void ParticipantController.registerConverters(WebDataBinder binder) {
        if (binder.getConversionService() instanceof GenericConversionService) {
            GenericConversionService conversionService = (GenericConversionService) binder.getConversionService();
            conversionService.addConverter(getParticipantConverter());
        }
    }
    
}
