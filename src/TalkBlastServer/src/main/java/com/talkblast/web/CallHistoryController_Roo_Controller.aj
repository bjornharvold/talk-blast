package com.talkblast.web;

import com.talkblast.domain.CallHistory;
import com.talkblast.domain.Participant;
import com.talkblast.domain.Uzer;
import java.lang.Long;
import java.lang.String;
import java.util.Collection;
import javax.validation.Valid;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.core.convert.converter.Converter;
import org.springframework.core.convert.support.GenericConversionService;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

privileged aspect CallHistoryController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String CallHistoryController.create(@Valid CallHistory callHistory, BindingResult result, ModelMap modelMap) {
        if (result.hasErrors()) {
            modelMap.addAttribute("callHistory", callHistory);
            addDateTimeFormatPatterns(modelMap);
            return "callhistorys/create";
        }
        callHistory.persist();
        return "redirect:/callhistorys/" + callHistory.getId();
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String CallHistoryController.createForm(ModelMap modelMap) {
        modelMap.addAttribute("callHistory", new CallHistory());
        addDateTimeFormatPatterns(modelMap);
        return "callhistorys/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String CallHistoryController.show(@PathVariable("id") Long id, ModelMap modelMap) {
        addDateTimeFormatPatterns(modelMap);
        modelMap.addAttribute("callhistory", CallHistory.findCallHistory(id));
        return "callhistorys/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String CallHistoryController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, ModelMap modelMap) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            modelMap.addAttribute("callhistorys", CallHistory.findCallHistoryEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) CallHistory.countCallHistorys() / sizeNo;
            modelMap.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            modelMap.addAttribute("callhistorys", CallHistory.findAllCallHistorys());
        }
        addDateTimeFormatPatterns(modelMap);
        return "callhistorys/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String CallHistoryController.update(@Valid CallHistory callHistory, BindingResult result, ModelMap modelMap) {
        if (result.hasErrors()) {
            modelMap.addAttribute("callHistory", callHistory);
            addDateTimeFormatPatterns(modelMap);
            return "callhistorys/update";
        }
        callHistory.merge();
        return "redirect:/callhistorys/" + callHistory.getId();
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String CallHistoryController.updateForm(@PathVariable("id") Long id, ModelMap modelMap) {
        modelMap.addAttribute("callHistory", CallHistory.findCallHistory(id));
        addDateTimeFormatPatterns(modelMap);
        return "callhistorys/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String CallHistoryController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size) {
        CallHistory.findCallHistory(id).remove();
        return "redirect:/callhistorys?page=" + ((page == null) ? "1" : page.toString()) + "&size=" + ((size == null) ? "10" : size.toString());
    }
    
    @ModelAttribute("participants")
    public Collection<Participant> CallHistoryController.populateParticipants() {
        return Participant.findAllParticipants();
    }
    
    @ModelAttribute("uzers")
    public Collection<Uzer> CallHistoryController.populateUzers() {
        return Uzer.findAllUzers();
    }
    
    Converter<CallHistory, String> CallHistoryController.getCallHistoryConverter() {
        return new Converter<CallHistory, String>() {
            public String convert(CallHistory callHistory) {
                return new StringBuilder().append(callHistory.getName()).append(" ").append(callHistory.getCreated()).append(" ").append(callHistory.getDelivery()).toString();
            }
        };
    }
    
    Converter<Participant, String> CallHistoryController.getParticipantConverter() {
        return new Converter<Participant, String>() {
            public String convert(Participant participant) {
                return new StringBuilder().append(participant.getName()).append(" ").append(participant.getPhone()).toString();
            }
        };
    }
    
    Converter<Uzer, String> CallHistoryController.getUzerConverter() {
        return new Converter<Uzer, String>() {
            public String convert(Uzer uzer) {
                return new StringBuilder().append(uzer.getUsername()).append(" ").append(uzer.getPazzword()).toString();
            }
        };
    }
    
    @InitBinder
    void CallHistoryController.registerConverters(WebDataBinder binder) {
        if (binder.getConversionService() instanceof GenericConversionService) {
            GenericConversionService conversionService = (GenericConversionService) binder.getConversionService();
            conversionService.addConverter(getCallHistoryConverter());
            conversionService.addConverter(getParticipantConverter());
            conversionService.addConverter(getUzerConverter());
        }
    }
    
    void CallHistoryController.addDateTimeFormatPatterns(ModelMap modelMap) {
        modelMap.addAttribute("callHistory_created_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
        modelMap.addAttribute("callHistory_delivery_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
    }
    
}
