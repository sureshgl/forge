package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Instance_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Instance_identifierContextExt extends AbstractBaseExt {

	public Instance_identifierContextExt(Instance_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Instance_identifierContext getContext() {
		return (Instance_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).instance_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Instance_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Instance_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}