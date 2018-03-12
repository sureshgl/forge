package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Config_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Config_declarationContextExt extends AbstractBaseExt {

	public Config_declarationContextExt(Config_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Config_declarationContext getContext() {
		return (Config_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).config_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Config_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Config_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}