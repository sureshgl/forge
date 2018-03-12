package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Config_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Config_identifierContextExt extends AbstractBaseExt {

	public Config_identifierContextExt(Config_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Config_identifierContext getContext() {
		return (Config_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).config_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Config_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Config_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}