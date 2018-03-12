package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Interface_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Interface_identifierContextExt extends AbstractBaseExt {

	public Interface_identifierContextExt(Interface_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Interface_identifierContext getContext() {
		return (Interface_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).interface_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Interface_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Interface_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}