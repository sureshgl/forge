package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Package_scopeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Package_scopeContextExt extends AbstractBaseExt {

	public Package_scopeContextExt(Package_scopeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Package_scopeContext getContext() {
		return (Package_scopeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).package_scope());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Package_scopeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Package_scopeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}