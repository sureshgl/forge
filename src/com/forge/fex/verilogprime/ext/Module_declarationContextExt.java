package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_ansi_headerContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_declarationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_nonansi_headerContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;
import com.forge.fex.verilogprime.utils.SingletonModuleUtility;

public class Module_declarationContextExt extends AbstractBaseExt {

	public Module_declarationContextExt(Module_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Module_declarationContext getContext() {
		return (Module_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).module_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Module_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Module_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public void collectModules() {
		Module_declarationContext ctx = getContext();
		String name = null;
		if (ctx.module_ansi_header() != null) {
			Module_ansi_headerContext module_ansi_header = ctx.module_ansi_header().extendedContext.getContext();
			name = module_ansi_header.module_identifier().extendedContext.getFormattedText();
		} else if (ctx.module_nonansi_header() != null) {
			Module_nonansi_headerContext module_nonansi_header = ctx.module_nonansi_header().extendedContext
					.getContext();
			name = module_nonansi_header.module_identifier().extendedContext.getFormattedText();
		}
		L.info("adding module "+name+" to SingletonModuleUtility");
		SingletonModuleUtility.getInstance().add(name, ctx);
		super.collectModules();
	}
}