package com.talkblast.web;

import com.talkblast.domain.Uzer;
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

privileged aspect UserController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String UserController.create(@Valid Uzer uzer, BindingResult result, ModelMap modelMap) {
        if (result.hasErrors()) {
            modelMap.addAttribute("uzer", uzer);
            return "uzers/create";
        }
        uzer.persist();
        return "redirect:/uzers/" + uzer.getId();
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String UserController.createForm(ModelMap modelMap) {
        modelMap.addAttribute("uzer", new Uzer());
        return "uzers/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String UserController.show(@PathVariable("id") Long id, ModelMap modelMap) {
        modelMap.addAttribute("uzer", Uzer.findUzer(id));
        return "uzers/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String UserController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, ModelMap modelMap) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            modelMap.addAttribute("uzers", Uzer.findUzerEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Uzer.countUzers() / sizeNo;
            modelMap.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            modelMap.addAttribute("uzers", Uzer.findAllUzers());
        }
        return "uzers/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String UserController.update(@Valid Uzer uzer, BindingResult result, ModelMap modelMap) {
        if (result.hasErrors()) {
            modelMap.addAttribute("uzer", uzer);
            return "uzers/update";
        }
        uzer.merge();
        return "redirect:/uzers/" + uzer.getId();
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String UserController.updateForm(@PathVariable("id") Long id, ModelMap modelMap) {
        modelMap.addAttribute("uzer", Uzer.findUzer(id));
        return "uzers/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String UserController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size) {
        Uzer.findUzer(id).remove();
        return "redirect:/uzers?page=" + ((page == null) ? "1" : page.toString()) + "&size=" + ((size == null) ? "10" : size.toString());
    }
    
    Converter<Uzer, String> UserController.getUzerConverter() {
        return new Converter<Uzer, String>() {
            public String convert(Uzer uzer) {
                return new StringBuilder().append(uzer.getUsername()).append(" ").append(uzer.getPazzword()).toString();
            }
        };
    }
    
    @InitBinder
    void UserController.registerConverters(WebDataBinder binder) {
        if (binder.getConversionService() instanceof GenericConversionService) {
            GenericConversionService conversionService = (GenericConversionService) binder.getConversionService();
            conversionService.addConverter(getUzerConverter());
        }
    }
    
}
